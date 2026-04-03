SMODS.Joker {
    key = "cunning",

    -- atlas = "jokers_71x95"",
    -- pos = { x = 0, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 50,
            mult = 8,
            xmult = 2
        }
    },

    loc_txt = {
        name = "Cunning Joker",
        text = {
            "If played hand contains a {C:attention}Pair{},",
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Jolly Joker + Sly Joker + The Duo){}"
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
        if context.joker_main and context.scoring_name == "Pair" then
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
        { name = "j_jolly" },
        { name = "j_sly" },
        { name = "j_duo" },
    },
    result_joker = "j_ultrafusion_cunning",
    cost = 4,
}