SMODS.Joker {
    key = "self_reflection",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = false,

    loc_txt = {
        name = "Self-Reflection",
        text = {
            "All cards are considered",
            "to be {C:attention}Face Cards{}",
            "Every played card counts",
            "in scoring",
            "{C:inactive}(Pareidolia + Splash){}"
        }
    },

    calculate = function(self, card, context)
        if UF.U.modify_scoring_hand_all_played(context) then
            return { add_to_hand = true }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_pareidolia" },
        { name = "j_splash" },
    },
    result_joker = "j_ultrafusion_self_reflection",
    cost = 8,
}