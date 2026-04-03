SMODS.Joker {
    key = "hand_sanitizer",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            count = 2,
            repetitions = 2
        }
    },

    loc_txt = {
        name = "Hand Sanitizer",
        text = {
            "Retrigger the first {C:attention}#1#{}",
            "scored cards {C:attention}#2#{} times",
            "{C:inactive}(Seltzer + Hanging Chad){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.count,
                card.ability.extra.repetitions
            }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.repetition_played_card(context) then
            local scoring_hand = context.scoring_hand or {}
            local limit = card.ability.extra.count

            for i = 1, math.min(limit, #scoring_hand) do
                if scoring_hand[i] == context.other_card then
                    return {
                        repetitions = card.ability.extra.repetitions
                    }
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_selzer" },
        { name = "j_hanging_chad" },
    },
    result_joker = "j_ultrafusion_hand_sanitizer",
    cost = 8,
}