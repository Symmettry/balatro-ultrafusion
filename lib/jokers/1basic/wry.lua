SMODS.Joker {
    key = "wry",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

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
        name = "Wry Joker",
        text = {
            "If played hand contains a {C:attention}Flush{},",
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Droll Joker + Crafty Joker + The Tribe){}"
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
        if context.joker_main and context.scoring_name == "Flush" then
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
        { name = "j_droll" },
        { name = "j_crafty" },
        { name = "j_tribe" },
    },
    result_joker = "j_ultrafusion_wry",
    cost = 4,
}