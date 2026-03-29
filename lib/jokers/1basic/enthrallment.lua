SMODS.Joker {
    key = "enthrallment",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 4
        }
    },

    loc_txt = {
        name = "Enthrallment",
        text = {
            "Played {C:attention}Face Cards{} give",
            "{X:mult,C:white}X#1#{} Mult when scored",
            "{C:inactive}(Idol + Triboulet){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.individual_played_card(context) then
            if context.other_card:is_face() then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_idol" },
        { name = "j_triboulet" },
    },
    result_joker = "j_ultrafusion_enthrallment",
    cost = 10,
}