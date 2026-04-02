SMODS.Joker {
    key = "sturdy",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            chips = 40,
            xmult = 0.25
        }
    },

    loc_txt = {
        name = "Sturdy Joker",
        text = {
            "Gives {C:blue}+#1#{} Chips and",
            "{X:mult,C:white}X#2#{} Mult for each",
            "{C:attention}Steel{} and/or {C:attention}Stone{} card",
            "in your full deck",
            "{C:inactive}(Stone Joker + Steel Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0

            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    local is_stone = playing_card.config
                        and playing_card.config.center == G.P_CENTERS.m_stone

                    local is_steel = playing_card.ability
                        and playing_card.ability.name == 'Steel Card'

                    if is_stone or is_steel then
                        count = count + 1
                    end
                end
            end

            return {
                chips = count * card.ability.extra.chips,
                xmult = 1 + count * card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_stone" },
        { name = "j_steel_joker" },
    },
    result_joker = "j_ultrafusion_sturdy",
    cost = 8,
}