SMODS.Joker {
    key = "shredded",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            mult = 30,
        }
    },

    loc_txt = {
        name = "Shredded Joker",
        text = {
            "{C:mult}+#1# Mult{}",
            "{C:inactive}(Half Joker + Misprint){}",
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
                mult = card.ability.extra.mult,
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_half" },
        { name = "j_misprint" },
    },
    result_joker = "j_ultrafusion_shredded",
    cost = 5,
}