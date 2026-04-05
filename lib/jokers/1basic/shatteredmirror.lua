SMODS.Joker {
    key = "shattered_mirror",

    rarity = "fusion",
    cost = 8,
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            Xmult_gain = 1.5,
            face_Xmult_gain = 1,
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
            "Destroyed {C:attention}face{} {C:attention}Glass Cards{}",
            "give an extra {X:mult,C:white}X#2#{} Mult",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult)",
            "{C:inactive}(Vampire + Glass Joker + Canio){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return {
            vars = {
                card.ability.extra.Xmult_gain,
                card.ability.extra.face_Xmult_gain,
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

            local gained = 0

            for _, removed_card in ipairs(context.removed) do
                if removed_card.ability and removed_card.ability.name == 'Glass Card' then
                    gained = gained + card.ability.extra.Xmult_gain

                    if removed_card:is_face() then
                        gained = gained + card.ability.extra.face_Xmult_gain
                    end
                end
            end

            if gained > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + gained

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
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
        { name = "j_caino" },
    },
    result_joker = "j_ultrafusion_shattered_mirror",
    cost = 8,
}