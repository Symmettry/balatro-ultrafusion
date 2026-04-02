SMODS.Joker {
    key = "cowboy",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            chips = 10,
            mult = 1
        }
    },

    loc_txt = {
        name = "Cowboy",
        text = {
            "{C:blue}+#1#{} Chips and {C:mult}+#2#{} Mult",
            "for every {C:money}$1{} you have",
            "{C:inactive}(Bull + Bootstraps){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local dollars = G.GAME.dollars or 0
            return {
                chips = dollars * card.ability.extra.chips,
                mult = dollars * card.ability.extra.mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_bull" },
        { name = "j_bootstraps" },
    },
    result_joker = "j_ultrafusion_cowboy",
    cost = 8,
}