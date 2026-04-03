SMODS.Joker {
    key = "road_trip",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult_gain = 0.25,
            xmult = 1
        }
    },

    loc_txt = {
        name = "Road Trip",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "for every discarded {C:attention}Jack{}",
            "Resets when {C:attention}Boss Blind{} is defeated",
            "Currently {X:mult,C:white}X#2#{} Mult",
            "{C:inactive}(Campfire + Hit the Road){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and not context.blueprint
            and context.other_card
            and not context.other_card.debuff
            and context.other_card:get_id() == 11 then

            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            return {
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.xmult }
                },
                colour = G.C.RED,
                delay = 0.45
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if context.beat_boss and card.ability.extra.xmult > 1 then
                card.ability.extra.xmult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_campfire" },
        { name = "j_hit_the_road" },
    },
    result_joker = "j_ultrafusion_road_trip",
    cost = 8,
}