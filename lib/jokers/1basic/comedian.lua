SMODS.Joker {
    key = "comedian",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    loc_txt = {
        name = "Comedian",
        text = {
            "Retrigger all played cards",
            "{C:inactive}(Hack + Sock and Buskin){}"
        }
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.blueprint then
            return {
                repetitions = 1
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_hack" },
        { name = "j_sock_and_buskin" },
    },
    result_joker = "j_ultrafusion_comedian",
    cost = 8,
}