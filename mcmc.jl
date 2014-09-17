using DataFrames
using GLM

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
	# subtract out column and row means, as instructed
	meanrollcall=copy(rollcall)
	for j in 1:size(meanrollcall,2)
		meanrollcall[:,j] = meanrollcall[:,j] - mean(meanrollcall[:,j])
	end
	for i in 1:size(meanrollcall,1)
		meanrollcall[i,:] = meanrollcall[i,:] - mean(meanrollcall[i,:])
	end
	trans = transpose(meanrollcall)

	# get nxn correlation matrix so that we can find eigenvalues for initial x0
	corr = meanrollcall*trans
	eigs = eig(corr)
	max_eig_loc = findmax(eigs[1])[2]

	x0 = eigs[2][:,max_eig_loc]

	x0
end

function initialize_beta(rollcall,init_x)
	#implement probit regression model

	# for each bill (j = 1:m)
	# perform regression using GLM on the pertaining col/ of the roll call matrix
	# and all the x0s
	# this will give one beta (x coeff) and one alpha (intercept) (= B_j and a_j)
	beta0 = Array(Float64, size(rollcall,2))
	alpha0 = Array(Float64, size(rollcall,2))
	for j in 1:size(rollcall,2)
		data = DataFrame(X=init_x,Y=rollcall[:,j])
		result = glm(Y~X,data,Binomial(),ProbitLink())
		beta0[j] = coef(result)[2]
		alpha0[j] = coef(result)[1]
	end

	#return initial beta and alpha
	(beta0, alpha0)
end


# function for iterative MCMC process
function update_vars(rollcall, x, beta, alpha)

	# first sample y* from Normal distribution N(x(t-1)beta(t-1) - alpha(t-1)),1)
	# truncated based on observed 1 or 0 below or above 0
	# for abstentions we sample y* from untruncated mu(t-1)

	# next sample beta

	(x, beta, alpha)
end

