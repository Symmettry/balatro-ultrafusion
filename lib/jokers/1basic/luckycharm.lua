SMODS.Joker {
    key = "lucky_charm",
    rarity = "fusion",
    cost = 10,
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            Xmult_gain = 0.1,
            Xmult = 1
        }
    },

    loc_txt = {
        name = "Lucky Charm",
        text = {
            "{C:attention}Triples{} all listed {C:green}probabilities{}",
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "every time a {C:attention}Lucky Card{} scores",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)",
            "{C:inactive}(Lucky Cat + Oops! All 6s){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        return {
            vars = {
                card.ability.extra.Xmult_gain,
                card.ability.extra.Xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * 3
            }
        end

        if context.individual
            and context.cardarea == G.play
            and context.other_card.lucky_trigger
            and not context.blueprint then

            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_lucky_cat" },
        { name = "j_oops" },
    },
    result_joker = "j_ultrafusion_lucky_charm",
    cost = 8,
}