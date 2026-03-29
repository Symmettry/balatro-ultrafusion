-- =========================================================
-- scoring name helpers
-- =========================================================

function UF.U.scoring_name(context, name)
    return context and context.scoring_name == name
end

function UF.U.is_high_card(context) return UF.U.scoring_name(context, "High Card") end
function UF.U.is_pair(context) return UF.U.scoring_name(context, "Pair") end
function UF.U.is_two_pair(context) return UF.U.scoring_name(context, "Two Pair") end
function UF.U.is_three_kind(context) return UF.U.scoring_name(context, "Three of a Kind") end
function UF.U.is_straight(context) return UF.U.scoring_name(context, "Straight") end
function UF.U.is_flush(context) return UF.U.scoring_name(context, "Flush") end
function UF.U.is_full_house(context) return UF.U.scoring_name(context, "Full House") end
function UF.U.is_four_kind(context) return UF.U.scoring_name(context, "Four of a Kind") end
function UF.U.is_straight_flush(context) return UF.U.scoring_name(context, "Straight Flush") end