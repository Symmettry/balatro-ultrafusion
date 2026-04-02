SMODS.current_mod.optional_features = function()
    return {
        object_weights = true
    }
end

LOAD = function(a) assert(SMODS.load_file(a))() end
LOAD("load.lua")