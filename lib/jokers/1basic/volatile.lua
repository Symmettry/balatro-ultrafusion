SMODS.Joker {
    key = "volatile",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 3, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 100,
            mult = 12,
        }
    },

    loc_txt = {
        name = "Volatile Joker",
        text = {
            "When playing a {C:attention}Straight{},",
            "{C:blue}+#1# Chips{} and {C:mult}+#2# Mult{}",
            "{C:inactive}(Crazy Joker + Devious Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mult }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Straight" then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_crazy" },
        { name = "j_devious" },
    },
    result_joker = "j_ultrafusion_volatile",
    cost = 4,
}