SMODS.Joker {
    key = "sage_prophet",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            xmult_gain = 0.1
        }
    },

    loc_txt = {
        name = "Sage Prophet",
        text = {
            "If hand is played with",
            "{C:money}$5{} or less, create a {C:tarot}Tarot{} card",
            "Gives {X:mult,C:white}X#1#{} Mult per",
            "{C:tarot}Tarot{} card used this run",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult){}",
            "{C:inactive}(Vagabond + Fortune Teller){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local tarots_used = 0
        for _, v in pairs(G.GAME.consumeable_usage or {}) do
            if v.set == 'Tarot' then
                tarots_used = tarots_used + (v.count or 0)
            end
        end

        return {
            vars = {
                card.ability.extra.xmult_gain,
                1 + (tarots_used * card.ability.extra.xmult_gain)
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local dollars = G.GAME.dollars or 0

            if dollars <= 5 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                            local tarot = create_card(
                                'Tarot',
                                G.consumeables,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                'ultrafusion_sage_prophet'
                            )

                            tarot:add_to_deck()
                            G.consumeables:emplace(tarot)
                            G.GAME.consumeable_buffer = 0

                            card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = localize('k_plus_tarot'),
                                colour = G.C.PURPLE
                            })
                        end
                        return true
                    end
                }))
            end
        end

        if context.joker_main then
            local tarots_used = 0
            for _, v in pairs(G.GAME.consumeable_usage or {}) do
                if v.set == 'Tarot' then
                    tarots_used = tarots_used + (v.count or 0)
                end
            end

            return {
                xmult = 1 + (tarots_used * card.ability.extra.xmult_gain)
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_vagabond" },
        { name = "j_fortune_teller" },
    },
    result_joker = "j_ultrafusion_sage_prophet",
    cost = 8,
}