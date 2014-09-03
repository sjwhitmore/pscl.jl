using SunlightAPIs
using DataFrames

my_auth="enter API key here"


all_bills = bill_search(my_auth, state="ca", chamber="upper", search_window="term")
all_leg = legislator_search(my_auth, state="ca", chamber="upper")

b_ids=[b["id"] for b in all_bills]
leg_ids = [l["leg_id"] for l in all_leg]
leg_id_symbols=Symbol[]
leg_id_symbols = [convert(Symbol, l) for l in leg_ids]

rollcall=DataFrame(fill(Int,length(leg_ids)), leg_id_symbols, length(b_ids))

bill_details = [bill_detail(my_auth, open_states_id = o) for o in b_ids]
for b in bill_details
	println(b["votes"])
end
#println(rollcall)
#for b in bill_ids


#println(bill_ids)
#println(leg_ids)
