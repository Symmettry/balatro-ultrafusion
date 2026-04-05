SMODS.Joker {
    key = "wizard_of_the_light",
    
    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            heart_xmult = 1.5,
            diamond_mult_per_unit = 1,
            dollars_per_unit = 1
        }
    },

    loc_txt = {
        name = "Wizard of the Light",
        text = {
            "Played {C:diamonds}Diamonds{} give",
            "{C:mult}+#1# Mult{} for every {C:money}$#2#{} you have when scored",
            "Played {C:hearts}Hearts{} give",
            "{X:mult,C:white}X#3#{} Mult when scored",
            "{C:inactive}(Heart Paladin + Diamond Bard){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.diamond_mult_per_unit, -- #1
                card.ability.extra.dollars_per_unit,      -- #2
                card.ability.extra.heart_xmult            -- #3
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            
            if context.other_card:is_suit("Diamonds") then
                local dollars = G.GAME.dollars or 0
                local per = card.ability.extra.dollars_per_unit

                return {
                    mult = math.floor(dollars / per) * card.ability.extra.diamond_mult_per_unit
                }
            end

            if context.other_card:is_suit("Hearts") then
                return {
                    xmult = card.ability.extra.heart_xmult
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_fuse_heart_paladin" },
        { name = "j_fuse_diamond_bard" },
    },
    result_joker = "j_ultrafusion_wizard_of_the_light",
    cost = 10,
}