SMODS.Joker {
    key = "midas_the_invisible_hand_of_god",

    rarity = "ultrafusion_legfusion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    cost = 32,

    config = {
        extra = {
            debt_limit = 1000,
            hands = 10,
            free = 5,

            gold_dollars = 10,
            gold_dollars_gain = 10,

            gold_xchips = 10,
            gold_xchips_gain = 10
        }
    },

    loc_txt = {
        name = "{C:attention}Midas, The Invisible Hand of God{}",
        text = {
            "{C:inactive}\"That scam artist works for me now.\"{}",
            "{C:red}-$#1#{} Debt Limit, {C:blue}+#2#{} Hands,",
            "{C:attention}#3#{} Free {C:attention}Rerolls{} per shop",
            "When {C:attention}Blind{} is selected, {C:red}Taxes{} all your money",
            "and adds {C:money}triple{} it to this Joker's {C:attention}Sell Value{}",
            "When scored, {C:attention}Gold Cards{} give {C:money}$#4#{}",
            "and {X:chips,C:white}X#5#{} Chips",
            "{C:inactive}(Increased by +100% whenever the shop is rerolled){}",
            "{C:inactive}(Triples this scaling rate at the start of each Ante){}",
            "{C:inactive}(Currently gains +$#6# and +X#7# Chips per reroll){}",
            "{C:inactive}All problems can be solved with enough money.{}",
            "{C:inactive}(The Rugpuller + The Overlord of Greed){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.debt_limit,
                card.ability.extra.hands,
                card.ability.extra.free,
                card.ability.extra.gold_dollars,
                card.ability.extra.gold_xchips,
                card.ability.extra.gold_dollars_gain,
                card.ability.extra.gold_xchips_gain
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.current_round.free_rerolls = (G.GAME.current_round.free_rerolls or 0) + card.ability.extra.free
            G.GAME.bankrupt_at = -card.ability.extra.debt_limit
            calculate_reroll_cost(true)
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.current_round.free_rerolls = math.max((G.GAME.current_round.free_rerolls or 0) - card.ability.extra.free, 0)
        if G.GAME then
            G.GAME.bankrupt_at = 0
        end
        calculate_reroll_cost(true)
    end,

    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls or 0
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.free
            calculate_reroll_cost(true)
        end

        if context.setting_blind and not context.blueprint then
            local current_money = G.GAME.dollars or 0

            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(-current_money)

                    if current_money ~= 0 then
                        card.ability.extra_value = (card.ability.extra_value or 0) + (current_money * 3)
                        card:set_cost()
                    end

                    ease_hands_played(card.ability.extra.hands)

                    SMODS.calculate_effect(
                        {
                            message = "Taxed",
                            colour = G.C.RED
                        },
                        context.blueprint_card or card
                    )

                    return true
                end
            }))

            return nil, true
        end

        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.blueprint then
            card.ability.extra.gold_dollars_gain = card.ability.extra.gold_dollars_gain * 3
            card.ability.extra.gold_xchips_gain = card.ability.extra.gold_xchips_gain * 3

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end

        if context.reroll_shop and not context.blueprint then
            card.ability.extra.gold_dollars = card.ability.extra.gold_dollars + card.ability.extra.gold_dollars_gain
            card.ability.extra.gold_xchips = card.ability.extra.gold_xchips + card.ability.extra.gold_xchips_gain

            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED
                    })
                    return true
                end
            }))
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local is_gold = context.other_card.config
                and context.other_card.config.center == G.P_CENTERS.m_gold

            if is_gold then
                return {
                    dollars = card.ability.extra.gold_dollars,
                    xchips = card.ability.extra.gold_xchips
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_the_rugpuller" },
        { name = "j_ultrafusion_the_overlord_of_greed" },
    },
    result_joker = "j_ultrafusion_midas_the_invisible_hand_of_god",
    cost = 1234,
}