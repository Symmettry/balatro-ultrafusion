-- =========================================================
-- hand/card helpers
-- =========================================================

function UF.U.card_id(card)
    return card and card.get_id and card:get_id() or nil
end

function UF.U.is_jack(card)
    return UF.U.card_id(card) == 11
end

function UF.U.is_queen(card)
    return UF.U.card_id(card) == 12
end

function UF.U.is_king(card)
    return UF.U.card_id(card) == 13
end

function UF.U.is_face(card)
    local id = UF.U.card_id(card)
    return id and id >= 11 and id <= 13
end

function UF.U.is_suit(card, suit)
    return card and card.is_suit and card:is_suit(suit)
end

function UF.U.is_black(card)
    return UF.U.is_suit(card, "Spades") or UF.U.is_suit(card, "Clubs")
end

function UF.U.is_red(card)
    return UF.U.is_suit(card, "Hearts") or UF.U.is_suit(card, "Diamonds")
end

function UF.U.card_not_debuffed(card)
    return card and not card.debuff
end

function UF.U.count_held(predicate)
    local n = 0
    for _, c in ipairs(UF.U.hand()) do
        if predicate(c) then
            n = n + 1
        end
    end
    return n
end

function UF.U.all_held(predicate)
    for _, c in ipairs(UF.U.hand()) do
        if not predicate(c) then
            return false
        end
    end
    return true
end

function UF.U.all_held_black()
    return UF.U.all_held(U.is_black)
end

function UF.U.held_queens()
    return UF.U.count_held(U.is_queen)
end

function UF.U.held_spade_queens()
    return UF.U.count_held(function(c)
        return UF.U.is_queen(c) and UF.U.is_suit(c, "Spades")
    end)
end

function UF.U.card_has_any_suit(card)
    if not card then
        return false
    end

    for k, _ in pairs(SMODS.get_enhancements(card) or {}) do
        if k == 'm_wild' or (G.P_CENTERS[k] and G.P_CENTERS[k].any_suit) then
            return true
        end

        if k == 'm_stone' and next(SMODS.find_card('j_mxms_rock_candy')) then
            return true
        end
    end

    return false
end