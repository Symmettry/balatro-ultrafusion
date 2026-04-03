SMODS.Joker {
    key = "el_triunvirate",
    
    -- atlas = "jokers_71x95"",
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
        if UF.U.to_disable_boss_blind(context) then
            local payout = UF.U.boss_blind_payout(card.ability.extra.dollars)
            UF.U.disable_boss_blind_with_event(card)
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
    result_joker = "j_ultrafusion_el_triunvirate",
    cost = 10,
}