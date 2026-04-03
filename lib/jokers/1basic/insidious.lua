SMODS.Joker {
    key = "insidious",

    -- atlas = "jokers_71x95"",
    -- pos = { x = 1, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 150,
            mult = 16,
            xmult = 4
        }
    },

    loc_txt = {
        name = "Insidious Joker",
        text = {
            "If played hand contains a",
            "{C:attention}Two Pair{} or {C:attention}Four of a Kind{},",
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Mad Joker + Clever Joker + The Family){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and
           (context.scoring_name == "Two Pair" or context.scoring_name == "Four of a Kind") then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_mad" },
        { name = "j_clever" },
        { name = "j_family" },
    },
    result_joker = "j_ultrafusion_insidious",
    cost = 4,
}