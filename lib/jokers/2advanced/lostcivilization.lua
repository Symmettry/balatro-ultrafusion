SMODS.Joker {
    key = "lost_civilization",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            xchips_gain = 0.25
        }
    },

    loc_txt = {
        name = "Lost Civilization",
        text = {
            "Played cards permanently gain {X:chips,C:white}X#1#{} Chips",
            "if they don't already have additional {X:chips,C:white}XChips{}",
            "when scored",
            "If the first hand of round is a {C:attention}High Card{},",
            "add a permanent copy of the scoring card to the deck",
            "If the first hand of round is a {C:attention}Pair{},",
            "randomly change the leftmost scored card's",
            "{C:attention}Enhancement{}, {C:attention}Edition{}, or {C:attention}Seal{}",
            "{C:inactive}(Ancestry + Forgotten Technology){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xchips_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.first_hand_drawn(context) and UF.U.not_blueprint(context) then
            local eval = function()
                return UF.U.is_first_hand() and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        end

        if UF.U.individual_played_card(context) and UF.U.not_blueprint(context) then
            local other = context.other_card
            other.ability.perma_x_chips = other.ability.perma_x_chips or 1

            if other.ability.perma_x_chips <= 1 then
                UF.U.add_perma_xchips(other, card.ability.extra.xchips_gain)
                return {
                    extra = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS },
                    colour = G.C.CHIPS
                }
            end
        end

        if UF.U.first_hand_high_card(context) and context.scoring_hand and context.scoring_hand[1] then
            local copied = UF.U.copy_playing_card_to_deck_and_hand(context.scoring_hand[1])
            return UF.U.copy_result(copied, G.C.CHIPS)
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_ancestry" },
        { name = "j_ultrafusion_forgotten_technology" },
    },
    result_joker = "j_ultrafusion_lost_civilization",
    cost = 12,
}