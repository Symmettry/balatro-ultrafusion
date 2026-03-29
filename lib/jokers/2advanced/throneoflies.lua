SMODS.Joker {
    key = "throne_of_lies",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            mult = 200,
            queen_xmult = 5
        }
    },

    loc_txt = {
        name = "Throne of Lies",
        text = {
            "{C:mult}+#1# Mult{} before cards score",
            "Each {C:spades}Queen of Spades{} held in hand",
            "gives {X:mult,C:white}X#2#{} Mult",
            "{C:inactive}(Matriarchy + Blind Spot){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.queen_xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.initial_scoring_step then
            return {
                mult = card.ability.extra.mult,
            }
        end
        if context.joker_main then
            local queens = UF.U.held_spade_queens()

            local xmult = 1
            for i = 1, queens do
                xmult = xmult * card.ability.extra.queen_xmult
            end

            return {
                xmult = xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_matriarchy" },
        { name = "j_ultrafusion_blind_spot" },
    },
    result_joker = "j_ultrafusion_throne_of_lies",
    cost = 12,
}