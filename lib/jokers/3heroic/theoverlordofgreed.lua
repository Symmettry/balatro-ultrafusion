SMODS.Joker {
    key = "the_overlord_of_greed",

    rarity = "ultrafusion_heroicfusion",
    blueprint_compat = true,

    config = {
        extra = {
            hands = 9,
            mult = 50,
            xmult = 5,
            sell_increase = 9
        }
    },

    loc_txt = {
        name = "{C:attention}The Overlord of Greed{}",
        text = {
            "{C:blue}+#1# Hands{}, {C:mult}+#2# Mult{}, {X:mult,C:white}X#3#{} Mult",
            "{C:attention}Jokers{} and {C:attention}Consumable{} cards gain",
            "{C:money}$#4#{} of {C:attention}Sell Value{} each time a {C:attention}Face Card{} scores",
            "{C:inactive}\"How rude. I only take what I need; I simply need more than everyone has.\"{}",
            "{C:inactive}(Golden Emperor + Oath Breaker + He Who Stole Christmas){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands,
                card.ability.extra.mult,
                card.ability.extra.xmult,
                card.ability.extra.sell_increase
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.hands)
                    SMODS.calculate_effect(
                        {
                            message = localize {
                                type = 'variable',
                                key = 'a_hands',
                                vars = { card.ability.extra.hands }
                            }
                        },
                        context.blueprint_card or card
                    )
                    return true
                end
            }))
            return nil, true
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if context.other_card:is_face() then
                local amount = card.ability.extra.sell_increase
                local affected = false

                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        j.ability.extra_value = (j.ability.extra_value or 0) + amount
                        j:set_cost()
                        affected = true
                    end
                end

                if G.consumeables and G.consumeables.cards then
                    for _, c in ipairs(G.consumeables.cards) do
                        c.ability.extra_value = (c.ability.extra_value or 0) + amount
                        c:set_cost()
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
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_golden_emperor" },
        { name = "j_ultrafusion_oath_breaker" },
        { name = "j_ultrafusion_he_who_stole_christmas" },
    },
    result_joker = "j_ultrafusion_the_overlord_of_greed",
    cost = 24,
}