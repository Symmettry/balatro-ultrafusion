SMODS.Joker {
    key = "architecture",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 12,

    loc_txt = {
        name = "Architecture",
        text = {
            "Copies the effects of up to",
            "two Jokers to the {C:attention}right{}",
            "Retriggers the Joker to the",
            "{C:attention}left{} {C:attention}2{} additional times",
            "{C:inactive}(Blueprint + Brainstorm){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local left_joker = nil
            local right_joker_1 = nil
            local right_joker_2 = nil

            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    left_joker = G.jokers.cards[i - 1]
                    right_joker_1 = G.jokers.cards[i + 1]
                    right_joker_2 = G.jokers.cards[i + 2]
                    break
                end
            end

            local compatible_1 = right_joker_1
                and right_joker_1 ~= card
                and right_joker_1.config
                and right_joker_1.config.center
                and right_joker_1.config.center.blueprint_compat

            local compatible_2 = right_joker_2
                and right_joker_2 ~= card
                and right_joker_2.config
                and right_joker_2.config.center
                and right_joker_2.config.center.blueprint_compat

            local compatibility_text =
                localize('k_' .. (compatible_1 and 'compatible' or 'incompatible'))
                .. "/"
                .. localize('k_' .. (compatible_2 and 'compatible' or 'incompatible'))

            local both_compatible = compatible_1 and compatible_2
            local both_incompatible = (not compatible_1) and (not compatible_2)

            local badge_colour = both_compatible
                and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
                or (both_incompatible
                    and mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
                    or mix_colours(G.C.BLUE, G.C.JOKER_GREY, 0.8))

            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {
                                ref_table = card,
                                align = "m",
                                colour = badge_colour,
                                r = 0.05,
                                padding = 0.06
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = ' ' .. compatibility_text .. ' ',
                                        colour = G.C.UI.TEXT_LIGHT,
                                        scale = 0.32 * 0.8
                                    }
                                },
                            }
                        }
                    }
                }
            }

            return {
                vars = {},
                main_end = main_end
            }
        end

        return { vars = {} }
    end,

    calculate = function(self, card, context)
        local left_joker = nil
        local right_joker_1 = nil
        local right_joker_2 = nil

        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                left_joker = G.jokers.cards[i - 1]
                right_joker_1 = G.jokers.cards[i + 1]
                right_joker_2 = G.jokers.cards[i + 2]
                break
            end
        end

        -- Retrigger Joker to the left 2 additional times
        if context.retrigger_joker_check
        and not context.retrigger_joker
        and left_joker
        and context.other_card == left_joker
        and left_joker ~= card then
            return {
                message = localize('k_again_ex'),
                repetitions = 2,
                card = card
            }
        end

        local ret_1 = SMODS.blueprint_effect(card, right_joker_1, context)
        local ret_2 = SMODS.blueprint_effect(card, right_joker_2, context)

        local ret = UF.U.merge_joker_effects(ret_1, ret_2)

        if ret then
            ret.colour = G.C.BLUE
        end

        return ret
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_blueprint" },
        { name = "j_brainstorm" },
    },
    result_joker = "j_ultrafusion_architecture",
    cost = 12,
}