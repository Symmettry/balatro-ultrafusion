SMODS.Joker {
    key = "unhinged",

    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 100,
            mult = 12,
            xmult = 3
        }
    },

    loc_txt = {
        name = "Unhinged Joker",
        text = {
            "If played hand contains a {C:attention}Pair{},",
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Zany Joker + Wily Joker + The Trio){}"
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
        { name = "j_zany" },
        { name = "j_wily" },
        { name = "j_trio" },
    },
    result_joker = "j_ultrafusion_unhinged",
    cost = 4,
}