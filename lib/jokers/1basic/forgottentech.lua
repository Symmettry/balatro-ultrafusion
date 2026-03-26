SMODS.Joker {
    key = "forgotten_technology",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            chip_gain = 25,
            xmult_gain = 0.25,
            xmult = 1
        }
    },

    loc_txt = {
        name = "Forgotten Technology",
        text = {
            "Played cards give {C:blue}+#1# Chips{} when scored",
            "This Joker gains {X:mult,C:white}X#2#{} Mult at start of round",
            "and whenever a playing card is added to your deck",
            "{C:inactive}(Currently {X:mult,C:white}X#3# Mult{}{C:inactive}){}",
            "{C:inactive}(Marble + Hologram){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chip_gain,
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.blueprint then
            return {
                chips = card.ability.extra.chip_gain
            }
        end

        if context.first_hand_drawn and not context.blueprint and G.GAME.current_round and G.GAME.current_round.hands_played == 0 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize('k_upgrade_ex')
            }
        end

        if context.playing_card_added and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize('k_upgrade_ex')
            }
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_marble_joker" },
        { name = "j_hologram" },
    },
    result_joker = "j_ultrafusion_forgotten_technology",
    cost = 8,
}