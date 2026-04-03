SMODS.Joker {
    key = "matriarchy",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            mult = 20,
            queen_mult = 15,
        }
    },

    loc_txt = {
        name = "Matriarchy",
        text = {
            "{C:mult}+#1# Mult{},",
            "plus {C:mult}+#2# Mult{} for each",
            "{C:attention}Queen{} held in hand",
            "{C:inactive}(Shoot the Moon + Raised Fist){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.queen_mult }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local queens = UF.U.held_queens()

            return {
                mult = card.ability.extra.mult + (queens * card.ability.extra.queen_mult)
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_shoot_the_moon" },
        { name = "j_raised_fist" },
    },
    result_joker = "j_ultrafusion_matriarchy",
    cost = 6,
}