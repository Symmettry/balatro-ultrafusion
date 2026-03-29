SMODS.Joker {
    key = "the_grand_archmage",

    rarity = "heroicfusion",
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            scored_xmult = 3,
            mult = 0,
            mult_gain_per_unit = 5,
            chips = 0,
            chips_gain_per_unit = 25,
            dollars_per_unit = 1,
            xmult = 1,
            wild_xmult_gain = 1
        }
    },

    loc_txt = {
        name = "The Grand Archmage",
        text = {
            "{C:inactive}\"Really? This is what you called me away from my studies for? Fine, I'll settle this quickly.\"{}",
            "{C:attention}Hearts{}, {C:attention}Diamonds{}, {C:attention}Spades{}, and {C:attention}Clubs{} are all considered to be the same suit",
            "Played cards give {X:mult,C:white}X#1#{} Mult when scored",
            "Played cards permanently grant this Joker {C:mult}+#2# Mult{} and {C:blue}+#3# Chips{}",
            "for every {C:money}$#4#{} you have when scored",
            "Played cards with {C:attention}Wild{} enhancement permanently grant this Joker {X:mult,C:white}X#5#{} Mult",
            "{C:inactive}(Currently {C:mult}+#6# Mult{}, {C:blue}+#7# Chips{}, {X:mult,C:white}X#8#{} Mult{C:inactive}){}",
            "{C:inactive}(Wizard of Light + Wizard of Darkness + Library of Scrolls){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.scored_xmult,        -- #1
                card.ability.extra.mult_gain_per_unit,  -- #2
                card.ability.extra.chips_gain_per_unit, -- #3
                card.ability.extra.dollars_per_unit == 0 and 0.0001 or card.ability.extra.dollars_per_unit,    -- #4
                card.ability.extra.wild_xmult_gain,     -- #5
                card.ability.extra.mult,                -- #6
                card.ability.extra.chips,               -- #7
                card.ability.extra.xmult                -- #8
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local dollars = G.GAME and G.GAME.dollars or 0
            local dollars_per_unit = card.ability.extra.dollars_per_unit == 0 and 0.0001 or card.ability.extra.dollars_per_unit
            local scale = math.floor(dollars / dollars_per_unit)

            card.ability.extra.mult = card.ability.extra.mult + (scale * card.ability.extra.mult_gain_per_unit)
            card.ability.extra.chips = card.ability.extra.chips + (scale * card.ability.extra.chips_gain_per_unit)

            local ret = {
                xmult = card.ability.extra.scored_xmult
            }

            if UF.U.card_has_any_suit(context.other_card) then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.wild_xmult_gain
                ret.message = localize('k_upgrade_ex')
                ret.colour = G.C.RED
            end

            return ret
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_wizard_of_the_light" },
        { name = "j_ultrafusion_wizard_of_the_dark" },
        { name = "j_ultrafusion_library_of_scrolls" },
    },
    result_joker = "j_ultrafusion_the_grand_archmage",
    cost = 18,
}