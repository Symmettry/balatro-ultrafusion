SMODS.Joker {
    key = "joker_whos_also_evil",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 4, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 512,
            mult = 64,
            xmult = 16
        }
    },

    loc_txt = {
        name = "Joker who's also Evil",
        text = {
            "If played hand contains a {C:attention}Straight Flush{},",
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Volatile Joker + Wry Joker){}"
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
        if context.joker_main and context.scoring_name == "Straight Flush" then
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
        { name = "j_ultrafusion_volatile" },
        { name = "j_ultrafusion_wry" },
    },
    result_joker = "j_ultrafusion_joker_whos_also_evil",
    cost = 6,
}