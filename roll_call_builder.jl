using SunlightAPIs
using DataFrames

chamber = "upper"
all_bills = bill_search(sunlight_key, state="ca", chamber="upper", search_window="term")
all_leg = legislator_search(sunlight_key, state="ca", chamber="upper")

b_ids=[b["id"] for b in all_bills]
leg_ids = [l["leg_id"] for l in all_leg]
leg_id_symbols=Symbol[]
leg_id_symbols = [convert(Symbol, l) for l in leg_ids]

#bill

print(leg_ids)
print(leg_id_symbols)


bill_details = [bill_detail(sunlight_key, open_states_id = o) for o in b_ids]
bill_votes = [b["votes"] for b in bill_details]
all_votes=Any[]
for b in bill_details
	for j in b["votes"]
		if j["chamber"] == chamber
			push!(all_votes,j)
		else
			continue
		end
	end
end

#print(bill_details[1])

rollcall=DataFrame([String,fill(Int,length(leg_ids))...], [:vote_id,leg_id_symbols...], length(all_votes))
#rollcall[:bill_id] = b_ids
#println(rollcall)

row_num=1
for v in all_votes
	#print(v)
	if v["chamber"] == chamber
		rollcall[row_num, :vote_id] = v["id"]
		for vote in v["yes_votes"]
			if vote["leg_id"] in leg_ids
				leg = convert(Symbol,(vote["leg_id"]))
				rollcall[row_num, leg] = 1
			else
				print("leg not there")
				print(vote["leg_id"])
				print(" ")
			end
		end
		for vote in v["no_votes"]
			if vote["leg_id"] in leg_ids
				leg2 = convert(Symbol,(vote["leg_id"]))
				rollcall[row_num,leg2] = 0
			else
				print("leg not there")
				print(vote["leg_id"])
				print(" ")
			end
		end
	else
		continue
	end
	row_num = row_num + 1
end

println(rollcall)
#println(rollcall)
#for b in bill_ids


#println(bill_ids)
#println(leg_ids)
