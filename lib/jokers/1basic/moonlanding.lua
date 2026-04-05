SMODS.Joker {
    key = "moon_landing",

    rarity = "fusion",
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            interest = 1,
            interest_gain = 2,
            dollars_per_interest = 5
        }
    },

    loc_txt = {
        name = "Moon Landing",
        text = {
            "Earn {C:money}$#1#{} of additional {C:attention}interest{}",
            "for every {C:money}$#3#{} you have",
            "at end of round",
            "Increase additional interest by {C:money}$#2#{}",
            "when {C:attention}Boss Blind{} is defeated",
            "{C:inactive}(Currently {C:money}$#1#{}{C:inactive} per {C:money}$#3#{}{C:inactive}){}",
            "{C:inactive}(Rocket + To The Moon){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.interest,
                card.ability.extra.interest_gain,
                card.ability.extra.dollars_per_interest
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if context.beat_boss then
                card.ability.extra.interest = card.ability.extra.interest + card.ability.extra.interest_gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MONEY
                }
            end

            local dollars = G.GAME.dollars or 0
            local payout = math.floor(dollars / card.ability.extra.dollars_per_interest) * card.ability.extra.interest

            if payout > 0 then
                return {
                    dollars = payout
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_rocket" },
        { name = "j_to_the_moon" },
    },
    result_joker = "j_ultrafusion_moon_landing",
    cost = 8,
}