using SunlightAPIs
using DataFrames

all_bills = bill_search(sunlight_key, state="ca", chamber="upper", search_window="term")
all_leg = legislator_search(sunlight_key, state="ca", chamber="upper")

b_ids=[b["id"] for b in all_bills]
leg_ids = [l["leg_id"] for l in all_leg]
leg_id_symbols=Symbol[]
leg_id_symbols = [convert(Symbol, l) for l in leg_ids]

rollcall=DataFrame(fill(Int,length(leg_ids)), leg_id_symbols, length(b_ids))

bill_details = [bill_detail(sunlight_key, open_states_id = o) for o in b_ids]
for b in bill_details
	println(b["votes"])
end
#println(rollcall)
#for b in bill_ids


#println(bill_ids)
#println(leg_ids)


function build_roll_call(key, state, chamber, term)
    term_str = !isempty(term) ? "term:$term" : "term"

    bills = bill_search(key, state = state, chamber = chamber, search_window = term_str)
    bill_ids = [ b["id"] for b in all_bills ]
    bill_details = query_bill_details(key, bill_ids)

    legislators = legislator_search(key, state = state, chamber = chamber, term = term)
    leg_ids = [ convert(Symbol, l["leg_id"]) for l in legislators ]

end

function query_bill_details(key, bill_ids)
    bill_details = Any[]

    @sync begin
        for bid in bill_ids
            @async begin
                push!(bill_details, bill_detail(key, open_states_id = bid))
            end
        end
    end

    bill_details
end
