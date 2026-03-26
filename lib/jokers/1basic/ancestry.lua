SMODS.Joker {
    key = "ancestry",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    loc_txt = {
        name = "Ancestry",
        text = {
            "If first hand of round has only {C:attention}1{} card,",
            "add a permanent copy with a",
            "randomized {C:attention}Seal{} to the deck",
            "when played and draw it to hand",
            "{C:inactive}(Certificate + DNA){}"
        }
    },

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            if not context.blueprint then
                local eval = function()
                    return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
                end
                juice_card_until(card, eval, true)
            end
        end

        if context.before
            and G.GAME.current_round
            and G.GAME.current_round.hands_played == 0
            and context.full_hand
            and #context.full_hand == 1
            and not context.blueprint then

            G.playing_card = (G.playing_card and G.playing_card + 1) or 1

            local card_copied = copy_card(context.full_hand[1], nil, nil, G.playing_card)

            local polled_seal = SMODS.poll_seal({ guaranteed = true, type_key = 'vremade_certificate_seal' })

            if card_copied and card_copied.set_seal then
                card_copied:set_seal(polled_seal, true)
            end

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
                            if G.GAME.blind then
                                G.GAME.blind:debuff_card(card_copied)
                            end
                            G.hand:sort()
                            SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                            return true
                        end
                    }))
                end
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_certificate" },
        { name = "j_dna" },
    },
    result_joker = "j_ultrafusion_ancestry",
    cost = 8,
}