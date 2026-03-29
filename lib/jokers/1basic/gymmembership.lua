SMODS.Joker {
    key = "gym_membership",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            x_mult = 36,
        }
    },

    loc_txt = {
        name = "Gym Membership",
        text = {
            "{X:mult,C:white}X#1#{} Mult on",
            "final hand of round",
            "{C:inactive}(Acrobat + Loyalty Card + Card Sharp){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.joker_main(context) and UF.U.is_final_hand() then
            return {
                xmult = card.ability.extra.x_mult,
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_acrobat" },
        { name = "j_loyalty_card" },
        { name = "j_card_sharp" },
    },
    result_joker = "j_ultrafusion_gym_membership",
    cost = 12,
}