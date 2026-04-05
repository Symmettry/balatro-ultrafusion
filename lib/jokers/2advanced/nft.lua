SMODS.Joker {
    key = "nft",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    cost = 16,

    config = {
        extra = {
            free = 2,
            mult = 3,
            mult_gain = 3,
            xmult = 0.25,
            xmult_gain = 0.25
        }
    },

    loc_txt = {
        name = "NFT",
        text = {
            "{C:attention}#1#{} free {C:attention}Rerolls{} per shop",
            "Other {C:attention}Jokers{} give {C:mult}+#2#{} Mult and {X:mult,C:white}X#3#{} Mult",
            "Increase these amounts by {C:attention}+100%{} whenever the shop is rerolled",
            "{C:inactive}(Collectible Baseball Card + Collectible Chaos Card + Dementia Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.free,
                card.ability.extra.mult,
                card.ability.extra.xmult
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.current_round.free_rerolls = (G.GAME.current_round.free_rerolls or 0) + card.ability.extra.free
            calculate_reroll_cost(true)
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.current_round.free_rerolls = math.max((G.GAME.current_round.free_rerolls or 0) - card.ability.extra.free, 0)
        calculate_reroll_cost(true)
    end,

    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls or 0
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.free
            calculate_reroll_cost(true)
        end

        if context.reroll_shop and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "Upgraded",
                        colour = G.C.RED
                    })
                    return true
                end
            }))
        end

        if context.other_joker and context.other_joker ~= card then
            return {
                mult = card.ability.extra.mult,
                xmult = 1 + card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_collectible_baseball_card" },
        { name = "j_fuse_collectible_chaos_card" },
        { name = "j_fuse_dementia_joker" },
    },
    result_joker = "j_ultrafusion_nft",
    cost = 16,
}