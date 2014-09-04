

include("apikeys.jl")
load_sunlight_key()

include("roll_call_builder.jl")
include("mcmc.jl")

rollcall=build_roll_call(sunlight_key, "al", "lower", "2011-2014")
x0=initialize_x0(rollcall)
print(rollcall)
print("This is x0:")
print(x0)