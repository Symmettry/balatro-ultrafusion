SMODS.Joker {
    key = "arcturus_high_sovereign_of_mana",

    rarity = "legfusion",
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            pre_score_repetitions = 1,
            dollars_per_unit = 1,
            xmult_gain = 0.9,
            xchips = 1,
            xchips_gain = 0.9,
            mult_gain = 9,
            chips_gain = 99,
            scored_xmult = 9,
            repetitions = 3,
            mult = 0,
            chips = 0,
            xmult = 1
        }
    },
    
    loc_txt = {
        name = "Arcturus, High Sovereign of Mana",
        text = {
            "{C:inactive}\"Finally, the library is sorted. At last, everything in its place.\"{}",
            "This Joker triggers its {C:blue}+Chips{}, {C:mult}+Mult{}, and {X:mult,C:white}XMult{} before Cards score.",
            "For each {C:money}$#1#{} you have when a played card scores, this Joker",
            "permanently gains {X:mult,C:white}X#2#{} Mult, {X:chips,C:white}X#3#{} Chips, {C:mult}+#4# Mult{}, and {C:blue}+#5# Chips{}.",
            "All cards are considered to be {C:attention}Kings{} and all suits.",
            "All played cards will score, give {X:mult,C:white}X#6#{} Mult, and will be retriggered {C:attention}thrice.{}",
            "{C:inactive}(Currently {C:mult}+#7# Mult{}, {C:blue}+#8# Chips{}, {X:mult,C:white}X#9#{} Mult{}, {X:chips,C:white}X#10#{} Chips{}{C:inactive}){}",
            "{C:inactive}\"...Ah- My apologies, did you need something?\"{}",
            "{C:inactive}(The Syndicate + The Grand Archmage){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local dollars_per_unit = card.ability.extra.dollars_per_unit == 0 and 0.0001 or card.ability.extra.dollars_per_unit

        return {
            vars = {
                dollars_per_unit,               -- #1
                card.ability.extra.xmult_gain, -- #2
                card.ability.extra.xchips_gain,-- #3
                card.ability.extra.mult_gain,  -- #4
                card.ability.extra.chips_gain, -- #5
                card.ability.extra.scored_xmult, -- #6
                card.ability.extra.mult,       -- #7
                card.ability.extra.chips,      -- #8
                card.ability.extra.xmult,      -- #9
                card.ability.extra.xchips      -- #10
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local dollars = G.GAME and G.GAME.dollars or 0
            local dollars_per_unit = card.ability.extra.dollars_per_unit == 0 and 0.0001 or card.ability.extra.dollars_per_unit
            local scale = math.floor(dollars / dollars_per_unit)

            card.ability.extra.xmult = card.ability.extra.xmult + (scale * card.ability.extra.xmult_gain)
            card.ability.extra.xchips = card.ability.extra.xchips + (scale * card.ability.extra.xchips_gain)
            card.ability.extra.mult = card.ability.extra.mult + (scale * card.ability.extra.mult_gain)
            card.ability.extra.chips = card.ability.extra.chips + (scale * card.ability.extra.chips_gain)

            return {
                xmult = card.ability.extra.scored_xmult
            }
        end

        if context.repetition and context.cardarea == G.play and not context.blueprint then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                xmult = card.ability.extra.xmult,
                x_chips = card.ability.extra.xchips
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_the_syndicate" },
        { name = "j_ultrafusion_the_grand_archmage" },
    },
    result_joker = "j_ultrafusion_arcturus_high_sovereign_of_mana",
    cost = 50,
}