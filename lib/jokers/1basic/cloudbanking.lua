SMODS.Joker {
    key = "cloud_banking",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            debt_limit = 50,
            dollars = 5
        }
    },

    loc_txt = {
        name = "Cloud Banking",
        text = {
            "Go up to {C:red}-$#1#{} in debt",
            "While at or below {C:money}$0{},",
            "earn {C:money}$#2#{} for each {C:attention}9{}",
            "in your full deck at end of round",
            "{C:inactive}(Currently {C:money}$#3#{}{C:inactive} per round){}",
            "{C:inactive}(Cloud 9 + Credit Card){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local nines = 0

        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 9 then
                    nines = nines + 1
                end
            end
        end

        local current = nines * card.ability.extra.dollars

        return {
            vars = {
                card.ability.extra.debt_limit,
                card.ability.extra.dollars,
                current
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.GAME then
            G.GAME.bankrupt_at = -card.ability.extra.debt_limit
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.GAME then
            G.GAME.bankrupt_at = 0
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local dollars = G.GAME.dollars or 0

            if dollars <= 0 then
                local nines = 0

                if G.playing_cards then
                    for _, playing_card in ipairs(G.playing_cards) do
                        if playing_card:get_id() == 9 then
                            nines = nines + 1
                        end
                    end
                end

                if nines > 0 then
                    return {
                        dollars = nines * card.ability.extra.dollars
                    }
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_cloud_9" },
        { name = "j_credit_card" },
    },
    result_joker = "j_ultrafusion_cloud_banking",
    cost = 8,
}