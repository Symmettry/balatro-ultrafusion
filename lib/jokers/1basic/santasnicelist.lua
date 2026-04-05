SMODS.Joker {
    key = "santas_nice_list",
    blueprint_compat = true,
    rarity = "fusion",
    cost = 8,

    config = { extra = { dollars = 1, poker_hand = 'High Card' } },

    loc_txt = {
        name = "Santa's Nice List",
        text = {
            "If played hand is a {C:attention}#2#{},",
            "add {C:money}$#1#{} of {C:attention}Sell Value{}",
            "to each held {C:attention}Joker{} and",
            "{C:attention}Consumable{} card",
            "Selected {C:attention}Poker Hand{}",
            "changes at end of round",
            "{C:inactive}(To Do List + Gift Card){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars,
                localize(card.ability.extra.poker_hand, 'poker_hands')
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
            local affected = false

            for _, joker in ipairs(G.jokers.cards) do
                joker.ability.extra_value = (joker.ability.extra_value or 0) + card.ability.extra.dollars
                joker:set_cost()
                affected = true
            end

            if G.consumeables and G.consumeables.cards then
                for _, consumable in ipairs(G.consumeables.cards) do
                    consumable.ability.extra_value = (consumable.ability.extra_value or 0) + card.ability.extra.dollars
                    consumable:set_cost()
                    affected = true
                end
            end

            if affected then
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end

            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'ultrafusion_santas_nice_list')

            return {
                message = localize('k_reset')
            }
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end

        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'ultrafusion_santas_nice_list')
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_todo_list" },
        { name = "j_gift" },
    },
    result_joker = "j_ultrafusion_santas_nice_list",
    cost = 8,
}