SMODS.Joker {
    key = "cunning",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 0, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 50,
            mult = 8,
        }
    },

    loc_txt = {
        name = "Cunning Joker",
        text = {
            "When playing a {C:attention}Pair{},",
            "{C:blue}+#1# Chips{} and {C:mult}+#2# Mult{}",
            "{C:inactive}(Jolly Joker + Sly Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Pair" then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_jolly" },
        { name = "j_sly" },
    },
    result_joker = "j_ultrafusion_cunning",
    cost = 4,
}