using SunlightAPIs
using DataFrames


function votes_for_chamber(bill_details, chamber)
    votes = Any[]

    for b in bill_details
        append!(votes, filter(b["votes"]) do v
            v["chamber"] == chamber
        end)
    end
    
    votes
end

function query_bill_details(key, bill_ids)
    bill_details = Any[]

    for bid in bill_ids
        push!(bill_details, bill_detail(key, open_states_id = bid))
    end

    # TODO: make bill_detail requests async
    # @sync begin
    #     for bid in bill_ids
    #         @async begin
    #             push!(bill_details, bill_detail(key, open_states_id = bid))
    #         end
    #     end
    # end

    bill_details
end

function build_roll_call(key, state, chamber, term)
    term_str = !isempty(term) ? "term:$term" : "term"

    legislators = legislator_search(key, state = state, chamber = chamber, term = term)
    leg_ids = [ convert(Symbol, l["leg_id"]) for l in legislators ]

    bills = bill_search(key, state = state, chamber = chamber, search_window = term_str)
    bill_ids = [ b["id"] for b in bills ]
    bill_details = query_bill_details(key, bill_ids)
    bill_votes = votes_for_chamber(bill_details, chamber)

    roll_call = Array(Int, length(leg_ids), length(bill_votes))  #fill(0.5, length(leg_ids), length(bill_votes))


    for i in 1:length(bill_votes)
        vote = bill_votes[i]
        leg_votes = fill(0, length(leg_ids))

        yes_votes = [ v["leg_id"] for v in vote["yes_votes"] ]
        no_votes = [ v["leg_id"] for v in vote["no_votes"] ]

        for j in 1:length(leg_ids)
            if string(leg_ids[j]) in yes_votes
                leg_votes[j] = 1
            elseif string(leg_ids[j]) in no_votes
                leg_votes[j] = 2
            end
        end

        roll_call[:, i] = leg_votes
    end

    roll_call
end
