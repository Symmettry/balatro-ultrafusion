SMODS.Joker {
    key = "self_reflection",
    
    -- atlas = "jokers_142x190",
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
        if context.modify_scoring_hand and not context.blueprint then
            return {
                add_to_hand = true
            }
        end
    end
}

local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    return card_is_face_ref(self, from_boss)
        or (self:get_id() and next(SMODS.find_card("j_ultrafusion_self_reflection")))
end

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_pareidolia" },
        { name = "j_splash" },
    },
    result_joker = "j_ultrafusion_self_reflection",
    cost = 8,
}