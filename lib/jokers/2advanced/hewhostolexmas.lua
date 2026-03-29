SMODS.Joker {
    key = "he_who_stole_christmas",
    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    cost = 14,

    config = {
        extra = {
            sell_increase = 4
        }
    },

    loc_txt = {
        name = "He Who Stole Christmas",
        text = {
            "When a hand is played, adds {C:money}$#1#{} of sell value",
            "to each held {C:attention}Joker{} and {C:attention}Consumable{} card",
            "{C:inactive}(Santa's Nice List + Golden Egg){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.sell_increase
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.full_hand and not context.blueprint then
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
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_santas_nice_list" },
        { name = "j_fuse_golden_egg" },
    },
    result_joker = "j_ultrafusion_he_who_stole_christmas",
    cost = 14,
}