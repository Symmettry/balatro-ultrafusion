SMODS.Joker {
    key = "magic_mirror",

    rarity = "ultrafusion_advfusion",
    cost = 12,
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 0.25,
            Xmult_gain_increase = 0.25
        }
    },

    loc_txt = {
        name = "Magic Mirror",
        text = {
            "Quadruples all listed probabilities",
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "every time a {C:attention}Lucky Card{} scores",
            "Increase this by {X:mult,C:white}X#2#{} Mult",
            "whenever a {C:attention}Glass Card{} breaks",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult)",
            "{C:inactive}(Currently gains {X:mult,C:white}X#4#{}{C:inactive} Mult)",
            "{C:inactive}(Lucky Charm + Shattered Mirror){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass

        return {
            vars = {
                card.ability.extra.Xmult_gain,
                card.ability.extra.Xmult_gain_increase,
                card.ability.extra.Xmult,
                card.ability.extra.Xmult_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * 4
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

        if context.remove_playing_cards
            and context.removed
            and not context.blueprint then

            local broken_glass = 0

            for _, removed_card in ipairs(context.removed) do
                if removed_card.ability and removed_card.ability.name == 'Glass Card' then
                    broken_glass = broken_glass + 1
                end
            end

            if broken_glass > 0 then
                card.ability.extra.Xmult_gain =
                    card.ability.extra.Xmult_gain +
                    (card.ability.extra.Xmult_gain_increase * broken_glass)

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_lucky_charm" },
        { name = "j_ultrafusion_shattered_mirror" },
    },
    result_joker = "j_ultrafusion_magic_mirror",
    cost = 10,
}