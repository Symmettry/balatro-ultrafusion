SMODS.Joker {
    key = "oath_breaker",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            hands = 6,
            mult = 20,
            xmult = 4
        }
    },

    loc_txt = {
        name = "Oath Breaker",
        text = {
            "{C:blue}+#1# Hands{}, {C:mult}+#2# Mult{}, {X:mult,C:white}X#3#{} Mult",
            "{C:inactive}(Stolen Artifact + Daoism){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands,
                card.ability.extra.mult,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.hands)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                        context.blueprint_card or card
                    )
                    return true
                end
            }))
            return nil, true
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
        { name = "j_ultrafusion_stolen_artifact" },
        { name = "j_ultrafusion_daoism" },
    },
    result_joker = "j_ultrafusion_oath_breaker",
    cost = 12,
}