
const _DEFAULT_SUNLIGHT_KEY_PATH = joinpath(dirname(@__FILE__), "sunlight.key")

function load_sunlight_key(file = _DEFAULT_SUNLIGHT_KEY_PATH)
    isfile(file) && (global sunlight_key = readall(file))
end
