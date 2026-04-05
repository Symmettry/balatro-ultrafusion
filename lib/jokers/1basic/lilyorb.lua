SMODS.Joker {
    key = "lil_yorb",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 6, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 222,
            xchips_gain = 0.22
        }
    },

    loc_txt = {
        name = "Lil' Yorb",
        text = {
            "{C:inactive}\"Every good mod needs a self-insert\"{}",
            "Played {C:attention}2s{} give {C:blue}+#1#{} Chips when scored",
            "This Joker gains {X:chips,C:white}X#2#{} Chip for each {C:attention}Blind{} skipped",
            "{C:inactive}(Currently {X:chips,C:white}X#3#{}{C:inactive} Chips){}",
            "{C:inactive}(Stuntman + Wee Joker + Throwback){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local skips = (G.GAME and G.GAME.skips) or 0

        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.xchips_gain,
                1 + (skips * card.ability.extra.xchips_gain)
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
                x_chips = 1 + (skips * card.ability.extra.xchips_gain)
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_stuntman" },
        { name = "j_wee" },
        { name = "j_throwback" },
    },
    result_joker = "j_ultrafusion_lil_yorb",
    cost = 8,
}