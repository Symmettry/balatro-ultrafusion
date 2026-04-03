SMODS.Joker {
    key = "wizard_of_the_dark",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            spade_chips = 100,
            club_mult = 30
        }
    },

    loc_txt = {
        name = "Wizard of the Dark",
        text = {
            "Played {C:spades}Spades{} give",
            "{C:blue}+#1# Chips{} when scored",
            "Played {C:clubs}Clubs{} give",
            "{C:mult}+#2# Mult{} when scored",
            "{C:inactive}(Spade Archer + Club Wizard){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.spade_chips,
                card.ability.extra.club_mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if context.other_card:is_suit("Spades") then
                return {
                    chips = card.ability.extra.spade_chips
                }
            end

            if context.other_card:is_suit("Clubs") then
                return {
                    mult = card.ability.extra.club_mult
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_fuse_spade_archer" },
        { name = "j_fuse_club_wizard" },
    },
    result_joker = "j_ultrafusion_wizard_of_the_dark",
    cost = 10,
}