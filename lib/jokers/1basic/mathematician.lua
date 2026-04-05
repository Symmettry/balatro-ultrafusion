SMODS.Joker {
    key = "mathematician",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            mult = 10,
            chips = 50
        }
    },

    loc_txt = {
        name = "Mathematician",
        text = {
            "Each played {C:attention}Ace{}, {C:attention}2{}, {C:attention}3{},",
            "{C:attention}5{}, or {C:attention}8{} gives",
            "{C:mult}+#1#{} Mult and {C:blue}+#2#{} Chips",
            "when scored",
            "{C:inactive}(Fibonacci + Scholar){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.chips
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card then
            local id = context.other_card:get_id()

            if id == 14 or id == 2 or id == 3 or id == 5 or id == 8 then
                return {
                    mult = card.ability.extra.mult,
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_fibonacci" },
        { name = "j_scholar" },
    },
    result_joker = "j_ultrafusion_mathematician",
    cost = 8,
}