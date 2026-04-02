SMODS.Joker {
    key = "memorial",
    rarity = "fusion",
    blueprint_compat = false,
    eternal_compat = false,
    cost = 8,

    config = {
        extra = {
            armed = false
        }
    },

    loc_txt = {
        name = "Memorial",
        text = {
            "{C:inactive}\"I *will* keep fighting for you...\"{}",
            "If played hand contains a {C:attention}Face Card{}, this Joker becomes {C:attention}armed{}",
            "While {C:attention}armed{}, will {C:red}self-destruct{} to prevent {C:attention}death{} regardless of score",
            "Otherwise, only prevents death if score is at least {C:attention}25%{} of required chips",
            "{C:inactive}(Currently #1#{}{C:inactive})",
            "{C:inactive}(Mr. Bones + Photograph){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (card and card.ability and card.ability.extra and card.ability.extra.armed) and "Armed" or "Unarmed"
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for _, scored_card in ipairs(context.scoring_hand or {}) do
                if scored_card:is_face() then
                    card.ability.extra.armed = true
                    return {
                        message = "Armed!",
                        colour = G.C.RED
                    }
                end
            end
        end

        if context.end_of_round and context.game_over and context.main_eval then
            local armed = card.ability.extra.armed
            local save_allowed = false

            if armed then
                save_allowed = true
            else
                local current_chips = (G.GAME and G.GAME.chips) or 0
                local required_chips = (G.GAME and G.GAME.blind and G.GAME.blind.chips) or 0
                save_allowed = current_chips >= (required_chips * 0.25)
            end

            if save_allowed then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))

                card.ability.extra.armed = false

                return {
                    message = localize('k_saved_ex'),
                    saved = 'ph_mr_bones',
                    colour = G.C.RED
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_mr_bones" },
        { name = "j_photograph" },
    },
    result_joker = "j_ultrafusion_memorial",
    cost = 8,
}