local mod = SMODS.current_mod

mod.config = mod.config or {}

local function apply_fusion_weight()
    UF.USED_INCREASE_WEIGHT = mod.config.fusion_weight and UF.INCREASE_WEIGHT or 10
end

mod.config_tab = function()
    local toggle = create_toggle({
        label = "Increase weight for fusion partners",
        ref_table = mod.config,
        ref_value = "fusion_weight",
        callback = function()
            apply_fusion_weight()
        end
    })

    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.2 },
                nodes = { toggle }
            }
        }
    }
end