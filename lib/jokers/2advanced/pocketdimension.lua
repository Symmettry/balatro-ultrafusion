SMODS.Joker {
    key = "pocket_dimension",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    cost = 16,

    config = {
        extra = {
            joker_slots = 2
        }
    },

    loc_txt = {
        name = "Pocket Dimension",
        text = {
            "{C:attention}+#1#{} Joker Slots",
            "Copies the effects of up to",
            "two Jokers in both {C:attention}directions{}",
            "Retriggers itself {C:attention}twice{} for",
            "each {C:attention}empty{} Joker Slot",
            "{C:inactive}(Currently {C:attention}#2#{}{C:inactive} retriggers){}",
            "{C:inactive}(Architecture + Antimatter Dimension){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local left_joker_1 = nil
        local left_joker_2 = nil
        local right_joker_1 = nil
        local right_joker_2 = nil
        local slots = 0
        local filled = 0

        if card.area and card.area == G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    left_joker_1 = G.jokers.cards[i - 1]
                    left_joker_2 = G.jokers.cards[i - 2]
                    right_joker_1 = G.jokers.cards[i + 1]
                    right_joker_2 = G.jokers.cards[i + 2]
                    break
                end
            end
        end

        if G.jokers and G.jokers.config then
            slots = G.jokers.config.card_limit or 0
        end

        if G.jokers and G.jokers.cards then
            filled = #G.jokers.cards
        end

        local current_retriggers = math.max(0, slots - filled) * 2

        local function is_compatible(other)
            return other
                and other ~= card
                and other.config
                and other.config.center
                and other.config.center.blueprint_compat
        end

        local compatible_1 = is_compatible(left_joker_2)
        local compatible_2 = is_compatible(left_joker_1)
        local compatible_3 = is_compatible(right_joker_1)
        local compatible_4 = is_compatible(right_joker_2)

        local compatible_count =
            (compatible_1 and 1 or 0) +
            (compatible_2 and 1 or 0) +
            (compatible_3 and 1 or 0) +
            (compatible_4 and 1 or 0)

        local compatibility_text =
            localize('k_' .. (compatible_1 and 'compatible' or 'incompatible'))
            .. "/"
            .. localize('k_' .. (compatible_2 and 'compatible' or 'incompatible'))
            .. "/"
            .. localize('k_' .. (compatible_3 and 'compatible' or 'incompatible'))
            .. "/"
            .. localize('k_' .. (compatible_4 and 'compatible' or 'incompatible'))

        local badge_colour =
            compatible_count == 4
            and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
            or (compatible_count == 0
                and mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
                or mix_colours(G.C.BLUE, G.C.JOKER_GREY, 0.8))

        local main_end = nil

        if card.area and card.area == G.jokers then
            main_end = {
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
                                }
                            }
                        }
                    }
                }
            }
        end

        return {
            vars = {
                card.ability.extra.joker_slots,
                current_retriggers
            },
            main_end = main_end
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
        end
    end,

    calculate = function(self, card, context)
        local left_joker_1 = nil
        local left_joker_2 = nil
        local right_joker_1 = nil
        local right_joker_2 = nil

        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                left_joker_1 = G.jokers.cards[i - 1]
                left_joker_2 = G.jokers.cards[i - 2]
                right_joker_1 = G.jokers.cards[i + 1]
                right_joker_2 = G.jokers.cards[i + 2]
                break
            end
        end

        if context.retrigger_joker_check
        and not context.retrigger_joker
        and context.other_card == card then
            local slots = 0
            local filled = 0

            if G.jokers and G.jokers.config then
                slots = G.jokers.config.card_limit or 0
            end

            if G.jokers and G.jokers.cards then
                filled = #G.jokers.cards
            end

            local empty_slots = math.max(0, slots - filled)

            if empty_slots > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = empty_slots * 2,
                    card = card
                }
            end
        end

        local ret_1 = SMODS.blueprint_effect(card, left_joker_2, context)
        local ret_2 = SMODS.blueprint_effect(card, left_joker_1, context)
        local ret_3 = SMODS.blueprint_effect(card, right_joker_1, context)
        local ret_4 = SMODS.blueprint_effect(card, right_joker_2, context)

        local ret = UF.U.merge_joker_effects(ret_1, ret_2)
        ret = UF.U.merge_joker_effects(ret, ret_3)
        ret = UF.U.merge_joker_effects(ret, ret_4)

        if ret then
            ret.colour = G.C.BLUE
        end

        return ret
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_architecture" },
        { name = "j_ultrafusion_antimatter_dimension" },
    },
    result_joker = "j_ultrafusion_pocket_dimension",
    cost = 16,
}