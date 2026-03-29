SMODS.Joker {
    key = "black_market",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "advfusion",
    blueprint_compat = false,
    perishable_compat = false,

    config = {
        extra = {
            mult = 0,
            mult_mod = 5,
            chips = 0,
            chip_mod = 25
        }
    },

    loc_txt = {
        name = "Black Market",
        text = {
            "{C:attention}Flushes{} and {C:attention}Straights{} can be made with {C:attention}4{} cards",
            "{C:attention}Straights{} can be made with a gap of {C:attention}1{} rank",
            "Every played card counts in scoring",
            "All cards are considered to be {C:attention}Face Cards{}",
            "When hand is played, this Joker",
            "permanently gains {C:mult}+#2# Mult{} and {C:blue}+#4# Chips{}",
            "{C:inactive}(Currently {C:mult}+#1# Mult{}, {C:blue}+#3# Chips{}{C:inactive}){}",
            "{C:inactive}(Back Alley + Spare Trousers + Self-Reflection){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_mod,
                card.ability.extra.chips,
                card.ability.extra.chip_mod
            }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.before(context) and UF.U.not_blueprint(context) then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end

        if UF.U.modify_scoring_hand_all_played(context) then
            return {
                add_to_hand = true
            }
        end

        if UF.U.joker_main(context) then
            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_back_alley" },
        { name = "j_ultrafusion_parkour_leggings" },
        { name = "j_ultrafusion_self_reflection" },
    },
    result_joker = "j_ultrafusion_black_market",
    cost = 12,
}