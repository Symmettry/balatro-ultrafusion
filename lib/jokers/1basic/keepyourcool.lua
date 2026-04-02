SMODS.Joker {
    key = "keep_your_cool",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            xmult = 3,
            odds = 8
        }
    },

    loc_txt = {
        name = "Keep Your Cool",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}#2# in #3#{} chance to create",
            "two {C:attention}Double Tags{}",
            "at end of round, then",
            "this Joker reverts into {C:attention}Cavendish{}",
            "{C:inactive}(Cavendish + Diet Cola){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

        return {
            vars = {
                card.ability.extra.xmult,
                numerator,
                denominator
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "keep_your_cool_revert", true)

            if pseudorandom(pseudoseed("keep_your_cool_revert")) < (numerator / denominator) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if not (card and card.area == G.jokers) then
                            return true
                        end

                        add_tag(Tag('tag_double'))
                        add_tag(Tag('tag_double'))
                        GIVE_JOKER("j_cavendish")
                        card:start_dissolve()

                        return true
                    end
                }))

                return {
                    message = localize('k_tag_ex'),
                    colour = G.C.GREEN
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_cavendish" },
        { name = "j_diet_cola" },
    },
    result_joker = "j_ultrafusion_keep_your_cool",
    cost = 8,
}