SMODS.Joker {
    key = "the_dauntless_sojourner",

    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "heroicfusion",
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
            "Played cards permanently gain {C:blue}+#1# Chips{}, {C:mult}+#2# Mult{}, and {C:money}+$#3#{} when scored",
            "Played {C:attention}Jacks{} permanently gain {X:mult,C:white}X#4#{} Mult and {X:chips,C:white}X#5#{} Chips when scored",
            "Retrigger all played cards",
            " ",
            "On first hand of round only:",
            "If hand is a {C:attention}High Card{}, create a permanent copy of the scored card played and draw it to hand",
            "If hand is a {C:attention}Pair{}, randomly change the leftmost card's {C:attention}Enhancement{}, {C:attention}Edition{}, or {C:attention}Seal{}",
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
        if UF.U.setting_blind(context) and UF.U.not_blueprint(context) then
            UF.U.disable_boss_blind(card, true)
        end

        if UF.U.first_hand_drawn(context) and UF.U.not_blueprint(context) then
            local eval = function()
                return UF.U.is_first_hand() and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        end

        if UF.U.before(context) and UF.U.not_blueprint(context) and UF.U.is_first_hand() and context.scoring_hand and context.scoring_hand[1] then
            local target = context.scoring_hand[1]

            if UF.U.is_high_card(context) then
                local card_copied = UF.U.copy_playing_card_to_deck_and_hand(target)
                return UF.U.copy_result(card_copied, G.C.CHIPS)
            end

            if UF.U.is_pair(context) then
                local choices = { "enhancement", "edition", "seal" }
                local choice = pseudorandom_element(choices, pseudoseed("dauntless_sojourner_modify"))

                if choice == "enhancement" then
                    local center = SMODS.poll_enhancement({
                        guaranteed = true,
                        type_key = "dauntless_sojourner_enhancement"
                    })
                    if center then
                        target:set_ability(center, nil, true)
                    end
                elseif choice == "edition" then
                    local edition = poll_edition("dauntless_sojourner_edition", nil, true, true)
                    if edition then
                        target:set_edition(edition, true, true)
                    end
                elseif choice == "seal" then
                    local seal = SMODS.poll_seal({
                        guaranteed = true,
                        type_key = "dauntless_sojourner_seal"
                    })
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

        if UF.U.individual_played_card(context) and UF.U.not_blueprint(context) and UF.U.is_final_hand() then
            local other = context.other_card

            UF.U.add_perma_bonus(other, card.ability.extra.chips)
            UF.U.add_perma_mult(other, card.ability.extra.mult)
            UF.U.add_perma_dollars(other, card.ability.extra.dollars)

            if UF.U.is_jack(other) then
                UF.U.add_perma_xmult(other, card.ability.extra.jack_xmult_gain)
                UF.U.add_perma_xchips(other, card.ability.extra.jack_xchips_gain)
            end

            return {
                extra = {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                },
                colour = G.C.CHIPS
            }
        end

        if UF.U.repetition_played_card(context) and UF.U.not_blueprint(context) and UF.U.is_final_hand() then
            return {
                repetitions = 1
            }
        end

        if context.end_of_round and context.game_over and context.main_eval then
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