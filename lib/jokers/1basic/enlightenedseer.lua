SMODS.Joker {
    key = "enlightened_seer",

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
        name = "Enlightened Seer",
        text = {
            "{C:green}#1# in #2#{} chance to create a",
            "{C:tarot}Tarot{} card when a {C:attention}Booster Pack{} is opened",
            "Create a {C:dark_edition}Negative{} {C:tarot}Fool{}",
            "when {C:attention}Blind{} is selected",
            "{C:inactive}(Cartomancer + Hallucination){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(
            card,
            card.ability.extra.numerator,
            card.ability.extra.denominator,
            "ultrafusion_enlightened_seer_tarot"
        )

        return {
            vars = {
                num,
                den
            }
        }
    end,

    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint then
            if SMODS.pseudorandom_probability(
                card,
                "ultrafusion_enlightened_seer_tarot",
                card.ability.extra.numerator,
                card.ability.extra.denominator,
                "ultrafusion_enlightened_seer_tarot"
            ) then
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
                                "ultrafusion_enlightened_seer_tarot"
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

        if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                        local fool = create_card(
                            "Tarot",
                            G.consumeables,
                            nil,
                            nil,
                            nil,
                            nil,
                            "c_fool",
                            "ultrafusion_enlightened_seer_fool"
                        )

                        if fool and fool.set_edition then
                            fool:set_edition({ negative = true }, true, true)
                        end

                        fool:add_to_deck()
                        G.consumeables:emplace(fool)
                        G.GAME.consumeable_buffer = 0

                        card_eval_status_text(card, "extra", nil, nil, nil, {
                            message = localize("k_plus_tarot"),
                            colour = G.C.PURPLE
                        })
                    end
                    return true
                end
            }))

            return nil, true
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_cartomancer" },
        { name = "j_hallucination" },
    },
    result_joker = "j_ultrafusion_enlightened_seer",
    cost = 8,
}