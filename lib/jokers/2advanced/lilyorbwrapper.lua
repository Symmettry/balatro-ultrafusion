SMODS.Joker {
    key = "lil_yorb_wrapper",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 7, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 222,
            flat_chips = 31,
            xchips_gain = 0.22
        }
    },

    loc_txt = {
        name = "Lil' Yorb the Wrapper",
        text = {
            "{C:inactive}\"Every good mod needs a self-insert\"{}",
            "Played {C:attention}2s{} give {C:blue}+#1#{} Chips when scored",
            "Gives {C:blue}+#2#{} Chips",
            "This Joker gains {X:chips,C:white}X#3#{} Chip for each {C:attention}Blind{} skipped",
            "{C:inactive}(Currently {X:chips,C:white}X#4#{}{C:inactive} Chips){}",
            "{C:inactive}(Crumpled Up Joker + Lil' Yorb){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local skips = (G.GAME and G.GAME.skips) or 0

        return {
            vars = {
                card.ability.extra.chips,       -- #1
                card.ability.extra.flat_chips,  -- #2
                card.ability.extra.xchips_gain, -- #3
                1 + (skips * card.ability.extra.xchips_gain) -- #4
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if context.other_card:get_id() == 2 then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end

        if context.joker_main then
            local skips = (G.GAME and G.GAME.skips) or 0

            return {
                chips = card.ability.extra.flat_chips,
                x_chips = 1 + (skips * card.ability.extra.xchips_gain)
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_crumpled_up" },
        { name = "j_ultrafusion_lil_yorb" },
    },
    result_joker = "j_ultrafusion_lil_yorb_wrapper",
    cost = 10,
}