SMODS.Joker {
    key = "hieroglyphics",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 2,
            light = true
        }
    },

    loc_txt = {
        name = "Hieroglyphics",
        text = {
            "{C:diamonds}Diamonds{} and {C:hearts}Hearts{} count as the same suit {C:inactive}(Light){}",
            "{C:spades}Spades{} and {C:clubs}Clubs{} count as the same suit {C:inactive}(Dark){}",
            "Played cards with a {C:attention}#2#{} suit give {X:mult,C:white}X#1#{} Mult when scored",
            "Switches to {C:attention}#3#{} suit at end of round",
            "{C:inactive}(Ancient Joker + Smeared Joker + Flower Pot){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.light and "Light" or "Dark",
                card.ability.extra.light and "Dark" or "Light"
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local is_light = context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds")
            local is_dark = context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs")

            if (card.ability.extra.light and is_light) or ((not card.ability.extra.light) and is_dark) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.light = not card.ability.extra.light
            return {
                message = localize('k_swap_ex')
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ancient_joker" },
        { name = "j_smeared" },
        { name = "j_flower_pot" },
    },
    result_joker = "j_ultrafusion_hieroglyphics",
    cost = 10,
}