SMODS.Joker {
    key = "grand_auditorium",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 4,
            repetitions = 2
        }
    },

    loc_txt = {
        name = "Grand Auditorium",
        text = {
            "Played cards give {X:mult,C:white}X#1#{} Mult when scored",
            "Retrigger all played cards {C:attention}#2#{} times",
            "{C:inactive}(Hand Sanitizer + Comedian + Enthrallment){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.repetitions
            }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.individual_played_card(context) then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if UF.U.repetition_played_card(context) then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_hand_sanitizer" },
        { name = "j_ultrafusion_comedian" },
        { name = "j_ultrafusion_enthrallment" },
    },
    result_joker = "j_ultrafusion_grand_auditorium",
    cost = 14,
}