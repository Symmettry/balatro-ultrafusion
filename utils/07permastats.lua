-- =========================================================
-- shared permanent stat helpers
-- =========================================================

function UF.U.add_perma_bonus(card, amt)
    card.ability.perma_bonus = (card.ability.perma_bonus or 0) + amt
end

function UF.U.add_perma_mult(card, amt)
    card.ability.perma_mult = (card.ability.perma_mult or 0) + amt
end

function UF.U.add_perma_dollars(card, amt)
    card.ability.perma_p_dollars = (card.ability.perma_p_dollars or 0) + amt
end

function UF.U.add_perma_xmult(card, amt)
    card.ability.perma_xmult = (card.ability.perma_xmult or 1) + amt
end

function UF.U.add_perma_xchips(card, amt)
    card.ability.perma_x_chips = (card.ability.perma_x_chips or 1) + amt
end