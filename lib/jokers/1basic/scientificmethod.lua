SMODS.Joker {
    key = "scientific_method",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            chips = 10,
            mult = 4
        }
    },

    loc_txt = {
        name = "Scientific Method",
        text = {
            "Gives {C:blue}+#1#{} Chips and {C:red}+#2#{} Mult for each card below",
            "{C:attention}#5#{} remaining in your deck",
            "{C:inactive}(Currently {C:blue}+#3#{} {C:inactive}Chips and {C:red}+#4#{} {C:inactive}Mult){}",
            "{C:inactive}(Erosion + Blue Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local init = (G.GAME and G.GAME.starting_deck_size or 52)
        local missing_cards = math.max(0,
            init - (#G.deck.cards or 0)
        )

        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.chips * missing_cards,
                card.ability.extra.mult * missing_cards,
                init,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local missing_cards = math.max(0, G.GAME.starting_deck_size - #G.deck.cards)

            return {
                chips = card.ability.extra.chips * missing_cards,
                mult = card.ability.extra.mult * missing_cards
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_erosion" },
        { name = "j_blue_joker" },
    },
    result_joker = "j_ultrafusion_scientific_method",
    cost = 8,
}