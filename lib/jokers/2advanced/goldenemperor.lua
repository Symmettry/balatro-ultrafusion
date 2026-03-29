SMODS.Joker {
    key = "golden_emperor",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,

    config = {
        extra = {
            dollars = 13
        }
    },

    loc_txt = {
        name = "Golden Emperor",
        text = {
            "Earn {C:money}$#1#{} whenever a {C:attention}face card{} scores",
            "All played {C:attention}unenhanced{} cards become {C:attention}Gold Cards{}",
            "{C:inactive}(Rigged Election + King Midas + Royal Decree){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.full_hand and not context.blueprint then
            for _, c in ipairs(context.full_hand) do
                if c.set_ability
                    and c.config
                    and c.config.center ~= G.P_CENTERS.m_gold
                    and c.ability
                    and c.ability.set == "Default" then
                    c:set_ability(G.P_CENTERS.m_gold, nil, true)
                end
            end
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if context.other_card:is_face() then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_rigged_election" },
        { name = "j_ultrafusion_king_midas" },
        { name = "j_fuse_royal_decree" },
    },
    result_joker = "j_ultrafusion_golden_emperor",
    cost = 12,
}