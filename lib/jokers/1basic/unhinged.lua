SMODS.Joker {
    key = "unhinged",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 80,
            mult = 10,
        }
    },

    loc_txt = {
        name = "Unhinged Joker",
        text = {
            "When playing a {C:attention}Two Pair{},",
            "{C:blue}+#1# Chips{} and {C:mult}+#2# Mult{}",
            "{C:inactive}(Mad Joker + Clever Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Two Pair" then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_mad" },
        { name = "j_clever" },
    },
    result_joker = "j_ultrafusion_unhinged",
    cost = 4,
}