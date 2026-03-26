SMODS.Joker {
    key = "insidious",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 1, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 100,
            mult = 12,
        }
    },

    loc_txt = {
        name = "Insidious Joker",
        text = {
            "When playing a {C:attention}Three of a Kind{},",
            "{C:blue}+#1# Chips{} and {C:mult}+#2# Mult{}",
            "{C:inactive}(Zany Joker + Wily Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Three of a Kind" then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_zany" },
        { name = "j_wily" },
    },
    result_joker = "j_ultrafusion_insidious",
    cost = 4,
}