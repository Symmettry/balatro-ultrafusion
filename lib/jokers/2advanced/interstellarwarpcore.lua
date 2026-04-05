SMODS.Joker {
    key = "interstellar_warp_core",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    perishable_compat = false,
    cost = 16,

    config = {
        extra = {
            xchips_gain = 0.2,
            xmult_gain = 0.2,
            known_levels = {}
        }
    },

    loc_txt = {
        name = "Interstellar Warp Core",
        text = {
            "{X:chips,C:white}X#1#{} Chips per time the played {C:attention}poker hand{} has been played",
            "{X:mult,C:white}X#2#{} Mult per level of the played {C:attention}poker hand{}",
            "Whenever a {C:attention}Poker Hand{} levels up,",
            "it gains additional {C:mult}+Mult{} equal to",
            "the number of times it has been played",
            "{C:inactive}(Space Fuel + Big Bang + Flag Bearer){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xchips_gain,
                card.ability.extra.xmult_gain
            }
        }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.known_levels = card.ability.extra.known_levels or {}

        for handname, handdata in pairs(G.GAME.hands or {}) do
            card.ability.extra.known_levels[handname] = handdata.level or 1
        end
    end,

    calculate = function(self, card, context)
        card.ability.extra.known_levels = card.ability.extra.known_levels or {}

        if not context.blueprint then
            for handname, handdata in pairs(G.GAME.hands or {}) do
                local current_level = handdata.level or 1
                local previous_level = card.ability.extra.known_levels[handname]

                if previous_level == nil then
                    card.ability.extra.known_levels[handname] = current_level
                elseif current_level > previous_level then
                    local level_diff = current_level - previous_level
                    local played_count = handdata.played or 0

                    handdata.mult = (handdata.mult or 0) + (played_count * level_diff)
                    card.ability.extra.known_levels[handname] = current_level

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    }
                end
            end
        end

        if context.joker_main and context.scoring_name then
            local handdata = G.GAME.hands[context.scoring_name]
            local played_count = handdata and handdata.played or 0
            local hand_level = handdata and handdata.level or 1

            return {
                xchips = 1 + (played_count * card.ability.extra.xchips_gain),
                xmult = 1 + (hand_level * card.ability.extra.xmult_gain)
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_space_fuel" },
        { name = "j_fuse_big_bang" },
        { name = "j_fuse_flag_bearer" },
    },
    result_joker = "j_ultrafusion_interstellar_warp_core",
    cost = 16,
}