SMODS.Joker {
    key = "young_cultist",
    rarity = "fusion",
    blueprint_compat = true,
    perishable_compat = false,
    cost = 8,
    config = {
        extra = {
            xmult_per_4_sell = 1,
            sell_gain_cap = 6
        }
    },
    loc_txt = {
        name = "Young Cultist",
        text = {
            "{X:mult,C:white}X#1#{} Mult per {C:money}$4{} of this Joker's {C:attention}Sell Value{}",
            "When {C:attention}Blind{} is selected, destroy adjacent {C:attention}Jokers{}",
            "Jokers destroyed this way add {C:money}1/4{} their {C:attention}Sell Value{} to",
            "this Joker's {C:attention}Sell Value{}",
            "Cannot change {C:attention}Sell Value{} by more than {C:money}$#2#{} at once",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult)",
            "{C:inactive}(Swashbuckler + Ceremonial Dagger + Madness){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        local sell_value = (card and card.sell_cost) or 0
        local xmult = 1 + math.floor(sell_value / 4) * card.ability.extra.xmult_per_4_sell

        return {
            vars = {
                card.ability.extra.xmult_per_4_sell,
                card.ability.extra.sell_gain_cap,
                xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if not G.jokers or not G.jokers.cards then
                        return true
                    end

                    local my_index = nil
                    for i, j in ipairs(G.jokers.cards) do
                        if j == card then
                            my_index = i
                            break
                        end
                    end

                    if not my_index then
                        return true
                    end

                    local to_destroy = {}
                    local left = G.jokers.cards[my_index - 1]
                    local right = G.jokers.cards[my_index + 1]

                    if left and left ~= card and not left.ability.eternal then
                        to_destroy[#to_destroy + 1] = left
                    end
                    if right and right ~= card and not right.ability.eternal then
                        to_destroy[#to_destroy + 1] = right
                    end

                    if #to_destroy == 0 then
                        return true
                    end

                    local total_gain = 0

                    for _, destroyed in ipairs(to_destroy) do
                        local destroyed_sell = destroyed.sell_cost or 0
                        total_gain = total_gain + (destroyed_sell / 4)

                        if destroyed.start_dissolve then
                            destroyed:start_dissolve()
                        end
                    end

                    local cap = card.ability.extra.sell_gain_cap
                    total_gain = math.max(-cap, math.min(cap, total_gain))

                    if total_gain ~= 0 then
                        card.ability.extra_value = (card.ability.extra_value or 0) + total_gain
                        card:set_cost()

                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_val_up'),
                            colour = total_gain >= 0 and G.C.MONEY or G.C.RED
                        })
                    end

                    return true
                end
            }))
            return nil, true
        end

        if context.joker_main then
            local sell_value = card.sell_cost or 0
            local xmult = 1 + math.floor(sell_value / 4) * card.ability.extra.xmult_per_4_sell

            return {
                xmult = xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_swashbuckler" },
        { name = "j_ceremonial" },
        { name = "j_madness" },
    },
    result_joker = "j_ultrafusion_young_cultist",
    cost = 8,
}