SMODS.Joker {
    key = "munchies",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            chips = 100,
            mult = 20,
            odds = 4
        }
    },

    loc_txt = {
        name = "Munchies",
        text = {
            "{C:blue}+#1#{} Chips",
            "{C:red}+#2#{} Mult",
            "{C:green}#3# in #4#{} chance to break into",
            "its constituent parts",
            "at end of round",
            "{C:inactive}(Ice Cream + Popcorn){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
                numerator,
                denominator
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "munchies_break", true)

            if pseudorandom(pseudoseed("munchies_break")) < (numerator / denominator) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if card and card.area == G.jokers then
                            GIVE_JOKER("j_ice_cream")
                            GIVE_JOKER("j_popcorn")
                            card:start_dissolve()
                        end
                        return true
                    end
                }))

                return {
                    message = localize('k_plus_joker'),
                    colour = G.C.GREEN
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ice_cream" },
        { name = "j_popcorn" },
    },
    result_joker = "j_ultrafusion_munchies",
    cost = 8,
}