SMODS.Joker {
    key = "the_dauntless_sojourner",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = false,
    eternal_compat = false,

    config = {
        extra = {
            chips = 100,
            mult = 10,
            dollars = 1,
            jack_xmult_gain = 1,
            jack_xchips_gain = 0.25
        }
    },

    loc_txt = {
        name = "The Dauntless Sojourner",
        text = {
            "{C:inactive}\"I'm excited to find out where we're heading next!\"{}",
            "All {C:attention}Boss Blinds{} are disabled",
            "Will self-destruct to prevent death,",
            "reverting into {C:attention}World Tourist{} and {C:attention}Lost Civilization{}",
            " ",
            "On final hand of round only:",
            "Played cards permanently gain {C:blue}+#1# Chips{},",
            "{C:mult}+#2# Mult{}, and {C:money}+$#3#{} when scored",
            "Played {C:attention}Jacks{} permanently gain",
            "{X:mult,C:white}X#4#{} Mult and {X:chips,C:white}X#5#{} Chips when scored",
            "Retrigger all played cards",
            " ",
            "On first hand of round only:",
            "If hand is a {C:attention}High Card{}, create a permanent copy",
            "of the scored card played and draw it to hand",
            "If hand is a {C:attention}Pair{}, randomly change the leftmost",
            "card's {C:attention}Enhancement{}, {C:attention}Edition{}, or {C:attention}Seal{}",
            "{C:inactive}(Survivalist + World Tourist + Lost Civilization){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.dollars,
                card.ability.extra.jack_xmult_gain,
                card.ability.extra.jack_xchips_gain
            }
        }
    end,

    calculate = function(self, card, context)
        local hands_left = (G.GAME.current_round and G.GAME.current_round.hands_left) or 0
        local final_hand = hands_left == 0
        local first_hand = G.GAME.current_round and G.GAME.current_round.hands_played == 0

        if context.setting_blind and G.GAME.blind and G.GAME.blind.boss then
            G.GAME.blind.disabled = true
        end

        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        end

        if context.before and not context.blueprint and first_hand and context.scoring_hand and context.scoring_hand[1] then
            local target = context.scoring_hand[1]

            if context.scoring_name == "High Card" then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local card_copied = copy_card(target, nil, nil, G.playing_card)
                card_copied:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, card_copied)
                G.hand:emplace(card_copied)
                card_copied.states.visible = nil

                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_copied:start_materialize()
                        return true
                    end
                }))

                return {
                    message = localize('k_copied_ex'),
                    colour = G.C.CHIPS,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.blind:debuff_card(card_copied)
                                G.hand:sort()
                                SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                                return true
                            end
                        }))
                    end
                }
            end

            if context.scoring_name == "Pair" then
                local choices = { "enhancement", "edition", "seal" }
                local choice = pseudorandom_element(choices, pseudoseed("dauntless_sojourner_modify"))

                if choice == "enhancement" then
                    local center = SMODS.poll_enhancement({ guaranteed = true, type_key = "dauntless_sojourner_enhancement" })
                    if center then
                        target:set_ability(center, nil, true)
                    end
                elseif choice == "edition" then
                    local edition = poll_edition("dauntless_sojourner_edition", nil, true, true)
                    if edition then
                        target:set_edition(edition, true, true)
                    end
                elseif choice == "seal" then
                    local seal = SMODS.poll_seal({ guaranteed = true, type_key = "dauntless_sojourner_seal" })
                    if seal then
                        target:set_seal(seal, true)
                    end
                end

                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up()
                        return true
                    end
                }))

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.FILTER
                }
            end
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint and final_hand then
            local other = context.other_card

            other.ability.perma_bonus = (other.ability.perma_bonus or 0) + card.ability.extra.chips
            other.ability.perma_mult = (other.ability.perma_mult or 0) + card.ability.extra.mult
            other.ability.perma_p_dollars = (other.ability.perma_p_dollars or 0) + card.ability.extra.dollars

            if other:get_id() == 11 then
                other.ability.perma_xmult = (other.ability.perma_xmult or 1) + card.ability.extra.jack_xmult_gain
                other.ability.perma_x_chips = (other.ability.perma_x_chips or 1) + card.ability.extra.jack_xchips_gain
            end

            return {
                extra = {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                },
                colour = G.C.CHIPS
            }
        end

        if context.repetition and context.cardarea == G.play and not context.blueprint and final_hand then
            return {
                repetitions = 1
            }
        end

        if context.end_of_round and context.game_over and context.main_eval then
            if G.GAME.chips / G.GAME.blind.chips >= 0.25 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')

                        local create_revert = function(center_key)
                            local new_joker = SMODS.create_card({
                                set = "Joker",
                                area = G.jokers,
                                key = center_key
                            })
                            if new_joker then
                                new_joker:add_to_deck()
                                G.jokers:emplace(new_joker)
                                new_joker:start_materialize()
                            end
                        end

                        create_revert("j_ultrafusion_world_tourist")
                        create_revert("j_ultrafusion_lost_civilization")

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
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_survivalist" },
        { name = "j_ultrafusion_world_tourist" },
        { name = "j_ultrafusion_lost_civilization" },
    },
    result_joker = "j_ultrafusion_the_dauntless_sojourner",
    cost = 20,
}