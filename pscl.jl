

include("apikeys.jl")
load_sunlight_key()

include("roll_call_builder.jl")
include("mcmc.jl")

rollcall=build_roll_call(sunlight_key, "al", "lower", "2011-2014")
x0=initialize_x0(rollcall)
print(rollcall)
print("This is x0:")
print(x0)
[beta0, alpha0] = initialize_beta(rollcall,x0)
print("This is beta0:")
print(beta0)
print("This is alpha0:")
print(alpha0)