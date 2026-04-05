SMODS.Joker {
    key = "collectible_baseball_card",

    rarity = "fusion",
    blueprint_compat = true,
    perishable_compat = false,
    cost = 8,

    config = {
        extra = {
            xmult = 1.5,
            xmult_gain = 0.25
        }
    },

    loc_txt = {
        name = "Collectible Baseball Card",
        text = {
            "Other {C:attention}Jokers{} give {X:mult,C:white}X#1#{} Mult",
            "Increase this amount by {X:mult,C:white}X#2#{} Mult whenever",
            "a {C:attention}Booster Pack{} is skipped",
            "{C:inactive}(Red Card + Baseball Card){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.xmult_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.xmult_gain }
                },
                colour = G.C.RED,
                delay = 0.45
            }
        end

        if context.other_joker and context.other_joker ~= card then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_red_card" },
        { name = "j_baseball" },
    },
    result_joker = "j_ultrafusion_collectible_baseball_card",
    cost = 8,
}