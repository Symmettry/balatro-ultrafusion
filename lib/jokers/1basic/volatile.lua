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
            xmult = 3
        }
    },

    loc_txt = {
        name = "Volatile Joker",
        text = {
            "If played hand contains a {C:attention}Straight{},",
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Crazy Joker + Devious Joker + The Order){}"
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
        if context.joker_main and context.scoring_name == "Straight" then
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
        { name = "j_crazy" },
        { name = "j_devious" },
        { name = "j_order" },
    },
    result_joker = "j_ultrafusion_volatile",
    cost = 4,
}