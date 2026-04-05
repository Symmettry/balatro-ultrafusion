SMODS.Joker {
    key = "library_of_scrolls",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            mult = 0,
            mult_gain = 5,
            chips = 0,
            chips_gain = 25,
            xmult = 1,
            xmult_gain = 0.25,
            xmult_scored = 2,
            light = true
        }
    },

    loc_txt = {
        name = "Library of Scrolls",
        text = {
            "{C:diamonds}Diamonds{} and {C:hearts}Hearts{} count as the same suit {C:inactive}(Light){}",
            "{C:spades}Spades{} and {C:clubs}Clubs{} count as the same suit {C:inactive}(Dark){}",
            "Each discarded card permanently grants this Joker",
            "{C:mult}+#2# Mult{}, {C:blue}+#4# Chips{}, and {X:mult,C:white}X#6#{} Mult",
            "Played cards with a {C:attention}#7#{} suit give {X:mult,C:white}X#8#{} Mult when scored",
            "Switches to {C:attention}#9#{} suit at end of round",
            "{C:inactive}(Currently {C:mult}+#1# Mult{}, {C:blue}+#3# Chips{}, {X:mult,C:white}X#5#{} Mult{C:inactive}){}",
            "{C:inactive}(Hieroglyphics + Renowned Poet){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,                         -- #1
                card.ability.extra.mult_gain,                    -- #2
                card.ability.extra.chips,                        -- #3
                card.ability.extra.chips_gain,                   -- #4
                card.ability.extra.xmult,                        -- #5
                card.ability.extra.xmult_gain,                   -- #6
                card.ability.extra.light and "Light" or "Dark", -- #7
                card.ability.extra.xmult_scored,                 -- #8
                card.ability.extra.light and "Dark" or "Light"  -- #9
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local is_light = context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds")
            local is_dark = context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs")

            if (card.ability.extra.light and is_light) or ((not card.ability.extra.light) and is_dark) then
                return {
                    xmult = card.ability.extra.xmult_scored
                }
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.light = not card.ability.extra.light
            return {
                message = localize('k_swap_ex')
            }
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_hieroglyphics" },
        { name = "j_ultrafusion_renowned_poet" },
    },
    result_joker = "j_ultrafusion_library_of_scrolls",
    cost = 14,
}