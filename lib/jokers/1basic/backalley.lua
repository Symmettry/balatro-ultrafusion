SMODS.Joker {
    key = "back_alley",
    
    -- atlas = "jokers_142x190",
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

    add_to_deck = function(self, card, from_debuff)
        G.GAME.back_alley = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.back_alley = false
    end,
}

local old_four_fingers = SMODS.four_fingers
SMODS.four_fingers = function(hand)
    if G and G.GAME and G.GAME.back_alley then
        return 4
    end
    return old_four_fingers(hand)
end
local smods_shortcut_ref = SMODS.shortcut
function SMODS.shortcut()
    if G and G.GAME and G.GAME.back_alley then
        return true
    end
    return smods_shortcut_ref()
end

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_four_fingers" },
        { name = "j_shortcut" },
    },
    result_joker = "j_ultrafusion_back_alley",
    cost = 7,
}