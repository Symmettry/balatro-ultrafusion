SMODS.Joker {
    key = "blind_spot",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 1.5
        }
    },

    loc_txt = {
        name = "Blind Spot",
        text = {
            "If all cards held in hand are",
            "{C:spades}Spades{} or {C:clubs}Clubs{}, played",
            "{C:spades}Spades{} and {C:clubs}Clubs{} each give",
            "{X:mult,C:white}X#1#{} Mult when scored",
            "{C:inactive}(Blackboard + Seeing Double){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.individual_played_card(context) then
            if UF.U.all_held_black() and UF.U.is_black(context.other_card) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_blackboard" },
        { name = "j_seeing_double" },
    },
    result_joker = "j_ultrafusion_blind_spot",
    cost = 8,
}