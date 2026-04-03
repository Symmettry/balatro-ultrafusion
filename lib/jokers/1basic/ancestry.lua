SMODS.Joker {
    key = "ancestry",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    loc_txt = {
        name = "Ancestry",
        text = {
            "If first hand of round has only {C:attention}1{} card,",
            "add a permanent copy with a",
            "randomized {C:attention}Seal{} to the deck",
            "when played and draw it to hand",
            "{C:inactive}(Certificate + DNA){}"
        }
    },

    calculate = function(self, card, context)
        if UF.U.first_hand_drawn(context) and UF.U.not_blueprint(context) then
            local eval = function()
                return UF.U.is_first_hand() and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        end

        if UF.U.first_hand_single_card(context) then
            local copied = UF.U.copy_playing_card_to_deck_and_hand(context.full_hand[1])
            local polled_seal = SMODS.poll_seal({ guaranteed = true, type_key = 'vremade_certificate_seal' })

            if copied and copied.set_seal then
                copied:set_seal(polled_seal, true)
            end

            return UF.U.copy_result(copied, G.C.CHIPS)
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_certificate" },
        { name = "j_dna" },
    },
    result_joker = "j_ultrafusion_ancestry",
    cost = 8,
}