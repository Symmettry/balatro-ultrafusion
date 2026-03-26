SMODS.Joker {
    key = "el_triunvirate",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = false,

    config = {
        extra = {
            dollars = 10,
        }
    },

    loc_txt = {
        name = "El Triunvirate",
        text = {
            "Disables all {C:attention}Boss Blinds{},",
            "and earns {C:money}$#1#{} x current {C:attention}Ante{}",
            "when it does so",
            "{C:inactive}(Luchador + Matador + Chicot){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.dollars }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind.boss then
            local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
            local payout = card.ability.extra.dollars * ante
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            delay(0.4)
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                    return true
                end
            }))

            return {
                dollars = payout
            }, true
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_luchador" },
        { name = "j_matador" },
        { name = "j_chicot" },
    },
    result_joker = "j_ultrafusion_martial_arts",
    cost = 10,
}