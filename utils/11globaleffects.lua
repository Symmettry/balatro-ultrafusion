-- =========================================================
-- global effect activity checks
-- presence-based first, manual override second
-- =========================================================

function UF.U.back_alley_active()
    return UF.U.count_joker("j_ultrafusion_back_alley") > 0
        or UF.U.count_joker("j_ultrafusion_black_market") > 0
        or UF.U.get_manual_effect("back_alley")
end

function UF.U.all_face_cards_active()
    return UF.U.count_joker("j_ultrafusion_self_reflection") > 0
        or UF.U.count_joker("j_ultrafusion_black_market") > 0
        or UF.U.get_manual_effect("all_face_cards")
end

function UF.U.splash_scoring_active()
    return UF.U.count_joker("j_ultrafusion_self_reflection") > 0
        or UF.U.count_joker("j_ultrafusion_black_market") > 0
        or UF.U.count_joker("j_ultrafusion_the_syndicate") > 0
        or UF.U.count_joker("j_ultrafusion_arcturus_high_sovereign_of_mana") > 0
        or UF.U.get_manual_effect("splash_scoring")
end

function UF.U.all_kings_active()
    return UF.U.count_joker("j_ultrafusion_the_syndicate") > 0
        or UF.U.count_joker("j_ultrafusion_arcturus_high_sovereign_of_mana") > 0
        or UF.U.get_manual_effect("all_kings")
end

function UF.U.smeared_suits_active()
    return UF.U.count_joker("j_ultrafusion_hieroglyphics") > 0
        or UF.U.count_joker("j_ultrafusion_library_of_scrolls") > 0
        or UF.U.get_manual_effect("smeared_suits")
end
function UF.U.all_suits_active()
    return UF.U.count_joker("j_ultrafusion_the_grand_archmage") > 0
        or UF.U.count_joker("j_ultrafusion_arcturus_high_sovereign_of_mana") > 0
end

function UF.U.king_midas_active()
    return UF.U.count_joker("j_ultrafusion_king_midas") > 0
end

function UF.U.free_planets()
    return UF.U.count_joker("j_ultrafusion_space_station") > 0
end

-- probably useless for now?

-- function UF.U.set_smeared_suits(active)
--     UF.U.set_manual_effect("smeared_suits", active)
-- end

-- function UF.U.set_all_kings(active)
--     UF.U.set_manual_effect("all_kings", active)
-- end

-- function UF.U.set_back_alley(active)
--     UF.U.set_manual_effect("back_alley", active)
-- end

-- function UF.U.set_all_face_cards(active)
--     UF.U.set_manual_effect("all_face_cards", active)
-- end

-- function UF.U.set_splash_scoring(active)
--     UF.U.set_manual_effect("splash_scoring", active)
-- end
