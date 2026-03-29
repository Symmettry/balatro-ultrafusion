SMODS.Joker {
    key = "the_syndicate",
    
    rarity = "heroicfusion",
    blueprint_compat = false,
    perishable_compat = false,

    config = {
        extra = {
            mult = 0,
            mult_mod = 5,
            chips = 0,
            chip_mod = 25,
            spade_xmult = 5,
            repetitions = 2
        }
    },

    loc_txt = {
        name = "The Syndicate",
        text = {
            "{C:inactive}\"We will do what must be done. We are at your command.\"{}",
            "All cards are considered {C:attention}Kings{}",
            "This Joker triggers its {C:blue}+Chips{} and {C:mult}+Mult{} before cards score",
            "When hand is played, this Joker permanently gains {C:mult}+#2# Mult{} and {C:blue}+#4# Chips{}",
            "Each {C:spades}Spade{} held in hand gives {X:mult,C:white}X#5#{} Mult",
            "All played cards will score and be retriggered {C:attention}#6#{} times",
            "{C:inactive}(Currently {C:mult}+#1# Mult{}{C:inactive},{} {C:blue}+#3# Chips{}{C:inactive}){}",
            "{C:inactive}(Grand Auditorium + Black Market + Throne of Lies){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_mod,
                card.ability.extra.chips,
                card.ability.extra.chip_mod,
                card.ability.extra.spade_xmult,
                card.ability.extra.repetitions
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

        if UF.U.repetition_played_card(context) and UF.U.not_blueprint(context) then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end

        if UF.U.joker_main(context) then
            local spades = UF.U.count_held(function(c)
                return UF.U.is_suit(c, "Spades")
            end)

            local xmult = 1
            for i = 1, spades do
                xmult = xmult * card.ability.extra.spade_xmult
            end

            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                xmult = xmult
            }
        end
    end
}


FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_grand_auditorium" },
        { name = "j_ultrafusion_black_market" },
        { name = "j_ultrafusion_throne_of_lies" },
    },
    result_joker = "j_ultrafusion_the_syndicate",
    cost = 20,
}