SMODS.Joker {
    key = "shattered_mirror",

    rarity = "fusion",
    cost = 8,
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            Xmult_gain = 2,
            Xmult = 1
        }
    },

    loc_txt = {
        name = "Shattered Mirror",
        text = {
            "{C:attention}Glass Cards{} are guaranteed",
            "to break when scored",
            "Whenever a {C:attention}Glass Card{} breaks,",
            "this Joker permanently gains",
            "{X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)",
            "{C:inactive}(Vampire + Glass Joker){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return {
            vars = {
                card.ability.extra.Xmult_gain,
                card.ability.extra.Xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.fix_probability 
            and context.identifier == 'glass'
            and not context.blueprint then

            return {
                numerator = context.denominator
            }
        end

        if context.remove_playing_cards
            and context.removed
            and not context.blueprint then

            for _, removed_card in ipairs(context.removed) do
                if removed_card.ability and removed_card.ability.name == 'Glass Card' then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT,
                        message_card = card
                    }
                end
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_vampire" },
        { name = "j_glass" },
    },
    result_joker = "j_ultrafusion_shattered_mirror",
    cost = 8,
}