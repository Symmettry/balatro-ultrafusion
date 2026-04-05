SMODS.Joker {
    key = "engineer",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    cost = 14,

    config = {
        extra = {
            chips = 31,
            mult = 4
        }
    },

    loc_txt = {
        name = "Engineer",
        text = {
            "For each card below",
            "{C:attention}initial deck size{} remaining in your deck,",
            "scored cards give {C:blue}+#1#{} Chips",
            "and {C:red}+#2#{} Mult when scored",
            "{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{} and",
            "{C:spectral}Spectral{} cards may appear multiple times",
            "{C:inactive}(Currently {C:blue}+#3#{} {C:inactive}Chips and {C:red}+#4#{} {C:inactive}Mult){}",
            "{C:inactive}(Scientific Method + Dynamic Duo + Subwoofer){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local missing_cards = math.max(
            0,
            (G.GAME and G.GAME.starting_deck_size or 52) - (#G.deck.cards or 0)
        )

        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.chips * missing_cards,
                card.ability.extra.mult * missing_cards
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual
        and context.cardarea == G.play
        and context.other_card then
            local missing_cards = math.max(0, G.GAME.starting_deck_size - #G.deck.cards)

            if missing_cards > 0 then
                return {
                    chips = card.ability.extra.chips * missing_cards,
                    mult = card.ability.extra.mult * missing_cards,
                    card = card
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_scientific_method" },
        { name = "j_fuse_dynamic_duo" },
        { name = "j_ultrafusion_subwoofer" },
    },
    result_joker = "j_ultrafusion_engineer",
    cost = 14,
}