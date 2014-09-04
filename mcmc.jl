using DataFrames

# function initialize_mcmc(rollcall,colnames)
# 	meanrollcall=copy(rollcall)
# 	for c in colnames:
# 		meanrollcall[c] = meanrollcall[c]-mean(meanrollcall[c])
# 	end
# 	iterator=eachrow(rollcall)
# 	for i in 1:length(iterator)
# 		sum=0
# 		for j in 1:length(iterator[i])
# 			sum=sum+iterator[i][j]
# 		end
# 		meanrow=sum/length(iterator[i])
# 		for k in colnames
# 			meanrow[i,k] = df[i,k] - meanrow
# 		end
# 	end
# end

function initialize_x0(rollcall)
	meanrollcall=copy(rollcall)
	for j in 1:size(meanrollcall,2)
		meanrollcall[:,j] = meanrollcall[:,j] - mean(meanrollcall[:,j])
	end
	for i in 1:size(meanrollcall,1)
		meanrollcall[i,:] = meanrollcall[i,:] - mean(meanrollcall[i,:])
	end
	trans = transpose(meanrollcall)
	corr = trans*meanrollcall
	eigs = eig(corr)
	x0 = eigs[2][1]

	x0
end

function obtain_start_beta(rollcall,init_x)
	#implement probit regression model
end
