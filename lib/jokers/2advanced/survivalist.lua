SMODS.Joker {
    key = "survivalist",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "advfusion",
    blueprint_compat = false,
    eternal_compat = false,

    config = {
        extra = {
            xmult = 50,
            chip_gain = 50
        }
    },

    loc_txt = {
        name = "Survivalist",
        text = {
            "On final hand of round only:",
            "{X:mult,C:white}X#1#{} Mult, retrigger all played cards,",
            "and played cards permanently gain {C:blue}+#2# Chips{}",
            "when {C:attention}scored{}",
            "Will {C:red}self-destruct{} to prevent {C:attention}death{}",
            "{C:inactive}(Camping Trip + Gym Membership + Mr. Bones){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.chip_gain
            }
        }
    end,

    calculate = function(self, card, context)
        local hands_left = (G.GAME.current_round and G.GAME.current_round.hands_left) or 0
        local final_hand = hands_left == 0

        if context.before and not context.blueprint and final_hand then
            for _, scored_card in ipairs(context.scoring_hand or {}) do
                scored_card.ability.perma_bonus = (scored_card.ability.perma_bonus or 0) + card.ability.extra.chip_gain
            end
        end

        if context.repetition and context.cardarea == G.play and not context.blueprint and final_hand then
            return {
                repetitions = 1
            }
        end

        if context.joker_main and final_hand then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.game_over and context.main_eval then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end
            }))
            return {
                message = localize('k_saved_ex'),
                saved = 'ph_mr_bones',
                colour = G.C.RED
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_fuse_camping_trip" },
        { name = "j_ultrafusion_gym_membership" },
        { name = "j_mr_bones" },
    },
    result_joker = "j_ultrafusion_survivalist",
    cost = 20,
}