SMODS.Joker {
    key = "daoism",

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 3,
            dollars = 8
        }
    },

    loc_txt = {
        name = "Daoism",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Lose all {C:attention}discards{}",
            "Earn {C:money}$#2#{} at end of round",
            "{C:inactive}(Ramen + Delayed Gratification){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.dollars
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(-G.GAME.current_round.discards_left, nil, true)
                    SMODS.calculate_effect(
                        { message = localize('k_reset') },
                        context.blueprint_card or card
                    )
                    return true
                end
            }))
            return nil, true
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            return {
                dollars = card.ability.extra.dollars
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ramen" },
        { name = "j_delayed_grat" },
    },
    result_joker = "j_ultrafusion_daoism",
    cost = 8,
}