SMODS.current_mod.optional_features = function()
    return {
        -- object_weights = true -- currently broken :skull:
    }
end

LOAD = function(a) assert(SMODS.load_file(a))() end
LOAD("load.lua")