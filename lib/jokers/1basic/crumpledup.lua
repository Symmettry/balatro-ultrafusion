SMODS.Joker {
    key = "crumpled_up",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 5, y = 0 },

    rarity = "advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            mult = 31
        }
    },

    loc_txt = {
        name = "Crumpled Up Joker",
        text = {
            "{C:mult}+#1# Mult{}",
            "{C:inactive}(Joker + Half Joker + Misprint){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_joker" },
        { name = "j_half" },
        { name = "j_misprint" },
    },
    result_joker = "j_ultrafusion_crumpled_up",
    cost = 5,
}