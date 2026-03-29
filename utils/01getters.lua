-- =========================================================
-- basic nil-safe getters
-- =========================================================

function UF.U.game()
    return G and G.GAME or nil
end

function UF.U.round()
    return UF.U.game() and UF.U.game().current_round or nil
end

function UF.U.round_resets()
    return UF.U.game() and UF.U.game().round_resets or nil
end

function UF.U.blind()
    return UF.U.game() and UF.U.game().blind or nil
end

function UF.U.hand()
    return G and G.hand and G.hand.cards or {}
end

function UF.U.played_hand(context)
    return (context and context.full_hand) or {}
end

function UF.U.scoring_hand(context)
    return (context and context.scoring_hand) or {}
end

function UF.U.played_size(context)
    return #U.played_hand(context)
end

function UF.U.scoring_size(context)
    return #U.scoring_hand(context)
end

function UF.U.hands_played()
    return (U.round() and UF.U.round().hands_played) or 0
end

function UF.U.hands_left()
    return (U.round() and UF.U.round().hands_left) or 0
end

function UF.U.discards_left()
    return (U.round() and UF.U.round().discards_left) or 0
end

function UF.U.ante()
    return (U.round_resets() and UF.U.round_resets().ante) or 0
end
