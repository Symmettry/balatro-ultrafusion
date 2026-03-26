SMODS.Joker {
    key = "lost_civilization",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xchips_gain = 0.25
        }
    },

    loc_txt = {
        name = "Lost Civilization",
        text = {
            "Played cards permanently gain {X:chips,C:white}X#1#{} Chips",
            "if they don't already have additional {X:chips,C:white}XChips{}",
            "when scored",
            "If the first hand of round is a {C:attention}High Card{},",
            "add a permanent copy of the scoring card to the deck",
            "If the first hand of round is a {C:attention}Pair{},",
            "randomly change the leftmost scored card's",
            "{C:attention}Enhancement{}, {C:attention}Edition{}, or {C:attention}Seal{}",
            "{C:inactive}(Ancestry + Forgotten Technology){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xchips_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local other = context.other_card
            other.ability.perma_x_chips = other.ability.perma_x_chips or 1

            if other.ability.perma_x_chips <= 1 then
                other.ability.perma_x_chips = other.ability.perma_x_chips + card.ability.extra.xchips_gain
                return {
                    extra = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS },
                    colour = G.C.CHIPS
                }
            end
        end

        if context.before and not context.blueprint and G.GAME.current_round and G.GAME.current_round.hands_played == 0 and context.scoring_hand then
            local target = context.scoring_hand[1]
            if not target then
                return
            end

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
                local choice = pseudorandom_element(choices, pseudoseed("lost_civilization_modify"))

                if choice == "enhancement" then
                    local center = SMODS.poll_enhancement({ guaranteed = true, type_key = "lost_civilization_enhancement" })
                    if center then
                        target:set_ability(center, nil, true)
                    end
                elseif choice == "edition" then
                    local edition = poll_edition("lost_civilization_edition", nil, true, true)
                    if edition then
                        target:set_edition(edition, true, true)
                    end
                elseif choice == "seal" then
                    local seal = SMODS.poll_seal({ guaranteed = true, type_key = "lost_civilization_seal" })
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
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_ancestry" },
        { name = "j_ultrafusion_forgotten_technology" },
    },
    result_joker = "j_ultrafusion_lost_civilization",
    cost = 12,
}