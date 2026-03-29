-- =========================================================
-- exact hand-size pattern checks
-- =========================================================

function UF.U.played_exactly(context, n)
    return UF.U.played_size(context) == n
end

function UF.U.scoring_exactly(context, n)
    return UF.U.scoring_size(context) == n
end

function UF.U.first_hand_high_card(context)
    return UF.U.before(context) and UF.U.not_blueprint(context) and UF.U.is_first_hand() and UF.U.is_high_card(context)
end

function UF.U.first_hand_pair(context)
    return UF.U.before(context) and UF.U.not_blueprint(context) and UF.U.is_first_hand() and UF.U.is_pair(context)
end

function UF.U.first_hand_single_card(context)
    return UF.U.before(context)
        and UF.U.not_blueprint(context)
        and UF.U.is_first_hand()
        and UF.U.played_exactly(context, 1)
end

function UF.U.two_pair_with_exactly_4_played(context)
    return UF.U.joker_main(context) and UF.U.is_two_pair(context) and UF.U.played_exactly(context, 4)
end

function UF.U.pair_main(context)
    return UF.U.joker_main(context) and UF.U.is_pair(context)
end

function UF.U.two_pair_main(context)
    return UF.U.joker_main(context) and UF.U.is_two_pair(context)
end

function UF.U.three_kind_main(context)
    return UF.U.joker_main(context) and UF.U.is_three_kind(context)
end

function UF.U.straight_main(context)
    return UF.U.joker_main(context) and UF.U.is_straight(context)
end

function UF.U.flush_main(context)
    return UF.U.joker_main(context) and UF.U.is_flush(context)
end