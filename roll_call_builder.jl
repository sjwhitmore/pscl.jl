using SunlightAPIs
using DataFrames

my_auth="d04a46b694524bfe9b822927129dd432"


all_bills = bill_search(my_auth, state="ca", chamber="upper", search_window="term")
all_leg = legislator_search(my_auth, state="ca", chamber="upper")

b_ids=[b["id"] for b in all_bills]
leg_ids = [l["leg_id"] for l in all_leg]
leg_id_symbols=Symbol[]
leg_id_symbols = [convert(Symbol, l) for l in leg_ids]

#bill

rollcall=DataFrame([String,fill(Int,length(leg_ids))...], [:bill_id,leg_id_symbols...], length(b_ids))
rollcall[:bill_id] = b_ids
println(rollcall)

bill_details = [bill_detail(my_auth, open_states_id = o) for o in b_ids[1:10]]
bill_votes = [b["votes"] for b in bill_details]
all_votes = [v[i] for i in length(bill_votes[j]), j in 1:length(bill_votes)]
for b in bill_details
	#name = convert(Symbol, o)
	row_num = 1
	while rollcall[row_num, :bill_id] != b["id"]
		row_num = row_num + 1
	end
	#println(row_num)
	for vote in b["votes"]
		vote["votes"]
		leg = convert(Symbol,(i["leg_id"]))
		rollcall[row_num, leg] = 1
	end
	#for j in b["votes"]["no_votes"]
	#	leg2 = convert(Symbol,(j["leg_id"]))
	#	rollcall[row_num,leg2] = 0
	#end
end

println(rollcall)
#println(rollcall)
#for b in bill_ids


#println(bill_ids)
#println(leg_ids)
