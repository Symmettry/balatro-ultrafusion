SMODS.Joker {
    key = "big_evil_yorb",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 8, y = 0 },

    rarity = "ultrafusion_heroicfusion",
    blueprint_compat = true,

    config = {
        extra = {
            chips = 22222,
            xchips = 1,
            xchips_gain = 22
        }
    },

    loc_txt = {
        name = "{C:purple}BIG EVIL YORB!!!{}",
        text = {
            "{C:inactive}\"hey its me yorb\"{}",
            "Played {C:attention}2s{} give {C:blue}+#1#{} Chips when scored",
            "When a {C:attention}2{} is scored, this Joker gains",
            "{X:chips,C:white}X#2#{} Chips for each {C:attention}Blind{} skipped {C:inactive}(#4#){}",
            "{C:inactive}(Currently {X:chips,C:white}X#3#{}{C:inactive} Chips){}",
            "{C:inactive}(Lil' Yorb the Wrapper + Evil Joker + Joker who's also Evil){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,            -- #1
                card.ability.extra.xchips_gain,      -- #2
                card.ability.extra.xchips,           -- #3
                (G and G.GAME and G.GAME.skips) or 0 -- #4
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if context.other_card:get_id() == 2 then
                local skips = (G.GAME and G.GAME.skips) or 0
                local gain = skips * card.ability.extra.xchips_gain

                if gain > 0 then
                    card.ability.extra.xchips = card.ability.extra.xchips + gain
                end

                return {
                    chips = card.ability.extra.chips,
                    message = localize('k_upgrade_ex')
                }
            end
        end

        if context.joker_main then
            return {
                x_chips = card.ability.extra.xchips
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_lil_yorb_wrapper" },
        { name = "j_ultrafusion_evil" },
        { name = "j_ultrafusion_joker_whos_also_evil" },
    },
    result_joker = "j_ultrafusion_big_evil_yorb",
    cost = 12,
}