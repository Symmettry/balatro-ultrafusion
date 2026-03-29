SMODS.Joker {
    key = "parkour_leggings",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            mult = 0,
            mult_mod = 4,
            chips = 0,
            chip_mod = 8
        }
    },

    loc_txt = {
        name = "Parkour Leggings",
        text = {
            "If played hand is a {C:attention}Two Pair{}",
            "that contains exactly {C:attention}4{} cards,",
            "this Joker gains {C:mult}+#2# Mult{} and",
            "{C:blue}+#4# Chips{}",
            "{C:inactive}(Currently {C:mult}+#1# Mult{}, {C:blue}+#3# Chips{}{C:inactive}){}",
            "{C:inactive}(Square Joker + Spare Trousers){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,      -- #1
                card.ability.extra.mult_mod,  -- #2
                card.ability.extra.chips,     -- #3
                card.ability.extra.chip_mod   -- #4
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint
            and context.scoring_name == "Two Pair"
            and #context.full_hand == 4 then

            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end,
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_square" },
        { name = "j_spare_trousers" },
    },
    result_joker = "j_ultrafusion_parkour_leggings",
    cost = 7,
}