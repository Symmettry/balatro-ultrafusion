SMODS.Joker {
    key = "blind_spot",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,

    config = {
        extra = {
            xmult = 1.5
        }
    },

    loc_txt = {
        name = "Blind Spot",
        text = {
            "If all cards held in hand are",
            "{C:spades}Spades{} or {C:clubs}Clubs{}, played",
            "{C:spades}Spades{} and {C:clubs}Clubs{} each give",
            "{X:mult,C:white}X#1#{} Mult when scored",
            "{C:inactive}(Blackboard + Seeing Double){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local all_black = true

            for _, held_card in ipairs(G.hand.cards or {}) do
                local is_spade = held_card:is_suit("Spades")
                local is_club = held_card:is_suit("Clubs")

                if not is_spade and not is_club then
                    all_black = false
                    break
                end
            end

            local played_is_spade = context.other_card:is_suit("Spades")
            local played_is_club = context.other_card:is_suit("Clubs")

            if all_black and (played_is_spade or played_is_club) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_blackboard" },
        { name = "j_seeing_double" },
    },
    result_joker = "j_ultrafusion_blind_spot",
    cost = 8,
}