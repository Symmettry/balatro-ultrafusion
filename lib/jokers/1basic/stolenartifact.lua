SMODS.Joker {
    key = "stolen_artifact",

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            hands = 3,
            mult = 15
        }
    },

    loc_txt = {
        name = "Stolen Artifact",
        text = {
            "{C:blue}+#1# Hands{}, {C:mult}+#2# Mult{}",
            "Lose all {C:attention}discards{}",
            "{C:inactive}(Burglar + Mystic Summit){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands,
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(-G.GAME.current_round.discards_left, nil, true)
                    ease_hands_played(card.ability.extra.hands)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                        context.blueprint_card or card
                    )
                    return true
                end
            }))
            return nil, true
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_burglar" },
        { name = "j_mystic_summit" },
    },
    result_joker = "j_ultrafusion_stolen_artifact",
    cost = 8,
}