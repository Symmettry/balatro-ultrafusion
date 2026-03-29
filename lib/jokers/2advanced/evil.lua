SMODS.Joker {
    key = "evil",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 3, y = 0 },

    rarity = "advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 256,
            mult = 32,
            xmult = 8
        }
    },

    loc_txt = {
        name = "Evil Joker",
        text = {
            "{C:blue}+#1# Chips{}, {C:mult}+#2# Mult{},",
            "and {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Cunning Joker + Unhinged Joker + Insidious Joker){}"
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
        if context.joker_main then
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
        { name = "j_ultrafusion_cunning" },
        { name = "j_ultrafusion_unhinged" },
        { name = "j_ultrafusion_insidious" },
    },
    result_joker = "j_ultrafusion_evil",
    cost = 6,
}