SMODS.Joker {
    key = "king_midas",

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            dollars = 5
        }
    },

    loc_txt = {
        name = "King Midas",
        text = {
            "Earn {C:money}$#1#{} whenever",
            "a {C:attention}face card{} scores",
            "All played cards become",
            "{C:attention}Gold Cards{}",
            "{C:attention}Gold Cards{} no longer give",
            "money when held in hand",
            "{C:inactive}(Midas Mask + Golden Ticket){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.full_hand and not context.blueprint then
            for _, c in ipairs(context.full_hand) do
                if c.set_ability and c.config.center ~= G.P_CENTERS.m_gold then
                    c:set_ability(G.P_CENTERS.m_gold, nil, true)
                end
            end
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if context.other_card:is_face() then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_midas_mask" },
        { name = "j_ticket" },
    },
    result_joker = "j_ultrafusion_king_midas",
    cost = 8,
}