SMODS.Joker {
    key = "yorb_galactic_menace",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 9, y = 0 },

    rarity = "ultrafusion_legfusion",
    blueprint_compat = false,

    loc_txt = {
        name = "{C:purple}Yorb, The Galactic Menace{}",
        text = {
            "{C:inactive}\"yo i'm on a friggin spaceship now??\"{}",
            "gives {C:blue}Chips{} (many of them)",
        }
    },

    calculate = function(self, card, context)
        if not context.joker_main or context.blueprint then
            return
        end

        return {
            chips = UF.U.one_yorbillion()
        }
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_the_final_frontier" },
        { name = "j_ultrafusion_big_evil_yorb" },
    },
    result_joker = "j_ultrafusion_yorb_galactic_menace",
    cost = 222,
}