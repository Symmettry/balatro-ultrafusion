-- =========================================================
-- copy / materialize / draw helpers
-- =========================================================

function UF.U.copy_playing_card_to_deck_and_hand(source_card)
    if not source_card then return nil end

    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
    local copied = copy_card(source_card, nil, nil, G.playing_card)
    if not copied then return nil end

    copied:add_to_deck()
    G.deck.config.card_limit = G.deck.config.card_limit + 1
    table.insert(G.playing_cards, copied)
    G.hand:emplace(copied)
    copied.states.visible = nil

    G.E_MANAGER:add_event(Event({
        func = function()
            copied:start_materialize()
            return true
        end
    }))

    return copied
end

function UF.U.finish_added_playing_card(card_added)
    if not card_added then return end

    G.E_MANAGER:add_event(Event({
        func = function()
            if G.GAME and G.GAME.blind and G.GAME.blind.debuff_card then
                G.GAME.blind:debuff_card(card_added)
            end
            if G.hand and G.hand.sort then
                G.hand:sort()
            end
            SMODS.calculate_context({ playing_card_added = true, cards = { card_added } })
            return true
        end
    }))
end

function UF.U.copy_result(card_added, colour)
    return {
        message = localize('k_copied_ex'),
        colour = colour or G.C.CHIPS,
        func = function()
            UF.U.finish_added_playing_card(card_added)
        end
    }
end