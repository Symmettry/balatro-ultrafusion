SMODS.Joker {
    key = "superstition",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            numerator = 1,
            denominator = 2
        }
    },

    loc_txt = {
        name = "Superstition",
        text = {
            "If played hand contains",
            "an {C:attention}8{} or a {C:attention}Straight{},",
            "{C:green}#1# in #2#{} chance to create a {C:tarot}Tarot{} card",
            "Effect is guaranteed if played hand",
            "is a {C:attention}Straight{} containing an {C:attention}8{}",
            "{C:inactive}(8 Ball + Superposition){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(
            card,
            card.ability.extra.numerator,
            card.ability.extra.denominator,
            "ultrafusion_superstition"
        )

        return {
            vars = {
                num,
                den
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.scoring_hand and not context.blueprint then
            local has_8 = false
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 8 then
                    has_8 = true
                    break
                end
            end

            local is_straight = context.scoring_name == "Straight"
            local qualifies = has_8 or is_straight

            if qualifies then
                local guaranteed = has_8 and is_straight
                local success = guaranteed or SMODS.pseudorandom_probability(
                    card,
                    "ultrafusion_superstition",
                    card.ability.extra.numerator,
                    card.ability.extra.denominator,
                    "ultrafusion_superstition"
                )

                if success then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                                local tarot = create_card(
                                    "Tarot",
                                    G.consumeables,
                                    nil,
                                    nil,
                                    nil,
                                    nil,
                                    nil,
                                    "ultrafusion_superstition"
                                )

                                tarot:add_to_deck()
                                G.consumeables:emplace(tarot)
                                G.GAME.consumeable_buffer = 0

                                card_eval_status_text(card, "extra", nil, nil, nil, {
                                    message = localize("k_plus_tarot"),
                                    colour = G.C.PURPLE
                                })
                            end
                            return true
                        end
                    }))
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_8_ball" },
        { name = "j_superposition" },
    },
    result_joker = "j_ultrafusion_superstition",
    cost = 8,
}