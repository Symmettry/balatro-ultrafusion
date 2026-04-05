SMODS.Joker {
    key = "rigged_election",

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            dollars = 5
        }
    },

    loc_txt = {
        name = "Rigged Election",
        text = {
            "Earn {C:money}$#1#{} whenever",
            "a {C:attention}face card{} is discarded",
            "{C:inactive}(Faceless Joker + Mail-In Rebate){}"
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
        if context.discard and context.other_card and not context.blueprint then
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
        { name = "j_faceless" },
        { name = "j_mail" },
    },
    result_joker = "j_ultrafusion_rigged_election",
    cost = 6,
}