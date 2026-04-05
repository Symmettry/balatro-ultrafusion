SMODS.Joker {
    key = "blood_witch",

    rarity = "ultrafusion_heroicfusion",
    cost = 16,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,

    config = {
        extra = {
            blood = 0.2,
            min_blood = 0.2,
            max_blood = 1,
            chips = 50,
            mult = 10,
            xmult = 2
        }
    },

    -- no emojis in description :((((
    loc_txt = {
        name = "{C:red}The Blood Witch{}",
        text = {
            "{C:inactive}It seems we meet again. Feels good to be back.{}",
            "{C:inactive}(Blood cannot fall below {C:red}#3#{}{C:inactive}){}",
            "{C:red}🩸#1#{} / {C:red}#2#🍷{}",
            
            "When {C:attention}Blind{} is selected, destroy adjacent {C:attention}Jokers{}",
            "and gain {C:red}🩸Blood{} from their {C:attention}Rarity{}",
            
            "All {C:green}probabilities{} are multiplied by {C:red}🩸Blood{}",
            
            "Scored {C:attention}Face Cards{} give {C:blue}+#4#{} Chips, {C:mult}+#5#{} Mult,",
            "and {X:mult,C:white}X#6#{} Mult; All values x Sell Value x 🩸Blood",
            
            "Played {C:attention}Lucky{} and {C:attention}Glass{} Cards are destroyed",
            
            "Destroyed {C:attention}Face Cards{} increase {C:red}Blood{} and {C:red}Maximum Blood{} by {C:attention}+1🍷{}",
            
            "{C:inactive}(Adolescent Witch + Magic Mirror + Canio){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass

        return {
            vars = {
                card.ability.extra.blood,
                card.ability.extra.max_blood,
                card.ability.extra.min_blood,
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil

            for i, joker in ipairs(G.jokers.cards) do
                if joker == card then
                    my_pos = i
                    break
                end
            end

            if my_pos then
                local to_destroy = {}

                if G.jokers.cards[my_pos - 1] then
                    to_destroy[#to_destroy + 1] = G.jokers.cards[my_pos - 1]
                end

                if G.jokers.cards[my_pos + 1] then
                    to_destroy[#to_destroy + 1] = G.jokers.cards[my_pos + 1]
                end

                local total_delta = 0

                for _, other_joker in ipairs(to_destroy) do
                    total_delta = total_delta + UF.U.BLOOD.get_rarity_blood_delta(other_joker.config.center.rarity)

                    other_joker.ability.eternal = nil
                    other_joker.getting_sliced = true

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            other_joker:start_dissolve(nil, true)
                            return true
                        end
                    }))
                end

                if total_delta ~= 0 then
                    card.ability.extra.blood = card.ability.extra.blood + total_delta
                    UF.U.BLOOD.clamp_blood(card)

                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED,
                        message_card = card
                    }
                end
            end
        end

        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * card.ability.extra.blood
            }
        end

        if context.individual
            and context.cardarea == G.play
            and UF.U.BLOOD.is_face_card(context.other_card) then

            local sell_value = card.sell_cost or 0
            local scalar = sell_value * card.ability.extra.blood

            return {
                chips = card.ability.extra.chips * scalar,
                mult = card.ability.extra.mult * scalar,
                xmult = card.ability.extra.xmult * scalar
            }
        end

        if context.destroy_card
            and context.cardarea == G.play
            and not context.blueprint
            and UF.U.BLOOD.is_lucky_or_glass(context.destroy_card) then

            if UF.U.BLOOD.is_face_card(context.destroy_card) then
                card.ability.extra.max_blood = card.ability.extra.max_blood + 1
                card.ability.extra.blood = card.ability.extra.blood + 1
                UF.U.BLOOD.clamp_blood(card)
            end

            return {
                remove = true
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_adolescent_witch" },
        { name = "j_ultrafusion_magic_mirror" },
    },
    result_joker = "j_ultrafusion_blood_witch",
    cost = 14,
}