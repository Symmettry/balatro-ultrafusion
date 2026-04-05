-- =========================================================
-- repeated round / timing checks
-- =========================================================

function UF.U.is_first_hand()
    return UF.U.hands_played() == 0
end

-- Use this for scored-card / repetition contexts after the hand is spent
function UF.U.is_final_hand()
    return UF.U.hands_left() == 0
end

-- Use this for "about to play the last hand" checks in before-context
function UF.U.is_last_hand_to_play(context)
    return UF.U.before(context) and UF.U.hands_left() <= 1
end

function UF.U.first_hand_drawn(context)
    return context and context.first_hand_drawn
end

function UF.U.before(context)
    return context and context.before
end

function UF.U.after(context)
    return context and context.after
end

function UF.U.joker_main(context)
    return context and context.joker_main
end

function UF.U.individual_played_card(context)
    return context and context.individual and context.cardarea == G.play and context.other_card
end

function UF.U.repetition_played_card(context)
    return context and context.repetition and context.cardarea == G.play and context.other_card
end

function UF.U.setting_blind(context)
    return context and context.setting_blind and context.blind
end

function UF.U.end_of_round(context)
    return context and context.end_of_round and context.main_eval
end

function UF.U.not_blueprint(context)
    return not (context and context.blueprint)
end


function UF.U.modify_scoring_hand_all_played(context)
    return context and context.modify_scoring_hand and UF.U.not_blueprint(context) and UF.U.splash_scoring_active()
end