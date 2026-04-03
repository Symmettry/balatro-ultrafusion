SMODS.Joker {
    key = "back_alley",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = false,

    loc_txt = {
        name = "Back Alley",
        text = {
            "{C:attention}Flushes{} and {C:attention}Straights{}",
            "can be made with {C:attention}4{} cards",
            "{C:attention}Straights{} can be made",
            "with a gap of {C:attention}1{} rank",
            "{C:inactive}(Four Fingers + Shortcut){}"
        }
    },
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_four_fingers" },
        { name = "j_shortcut" },
    },
    result_joker = "j_ultrafusion_back_alley",
    cost = 7,
}