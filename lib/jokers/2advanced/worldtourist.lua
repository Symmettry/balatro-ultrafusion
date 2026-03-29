SMODS.Joker {
    key = "world_tourist",
    
    -- atlas = "jokers_142x190",
    -- pos = { x = 2, y = 0 },

    rarity = "advfusion",
    blueprint_compat = true,
    eternal_compat = false,

    config = {
        extra = {
            dollars = 10,
            xmult_gain = 0.25,
            xmult = 1
        }
    },

    loc_txt = {
        name = "World Tourist",
        text = {
            "Disables all {C:attention}Boss Blinds{},",
            "and earns {C:money}$#1#{} x current {C:attention}Ante{}",
            "when it does so",
            "This Joker gains {X:mult,C:white}X#2#{} Mult",
            "each time a {C:attention}Jack{} scores",
            "{C:inactive}Currently{} {X:mult,C:white}X#3#{} {C:inactive}Mult{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 0
        return {
            vars = {
                card.ability.extra.dollars * ante,
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if UF.U.to_disable_boss_blind(context) then
            local payout = UF.U.boss_blind_payout(card.ability.extra.dollars)
            UF.U.disable_boss_blind_with_event(card)
            return {
                dollars = payout
            }, true
        end

        if context.individual and context.cardarea == G.play and not context.blueprint
            and context.other_card
            and not context.other_card.debuff
            and context.other_card:get_id() == 11 then

            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            return {
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.xmult }
                },
                colour = G.C.RED,
                delay = 0.45
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
        { name = "j_ultrafusion_road_trip" },
        { name = "j_fuse_commercial_driver" },
        { name = "j_ultrafusion_el_triunvirate" },
    },
    result_joker = "j_ultrafusion_world_tourist",
    cost = 12,
}