-- Fucking end my stupid chud life...

if not UF.MODS.POLTERWORX then
    SMODS.Scoring_Calculation {
        key = "uf_twbb_bloodmath",
        order = 10,
        text = "^",
        func = function(self, chips, mult, flames)
            return to_big(chips) ^ to_big(mult)
        end
    }
end

SMODS.Joker {
    key = "there_will_be_blood",

    rarity = "ultrafusion_ultfusion",
    cost = 999,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,

    config = {
        extra = {
            joker_slots = 9,
            hand_size = 99,
            consumable_slots = 999,

            min_blood = 0,
            blood = 1e308,

            prev_final_operator = nil,
            prev_final_operator_offset = nil,
            operator_applied = false,

            prev_scoring_calc = nil,
            custom_calc_active = false,
        }
    },

    loc_txt = {
        name = "{C:red}There Will Be Blood.{}",
        text = {
            "{C:inactive}\"Quite brisk. How amusing. Let us finish this, Partner.\"{}",
            "{C:red}🩸Unlimited.🍷{}",
            "{C:attention}+#1#{} Joker Slots, {C:attention}+#2#{} Hand Size, and",
            "{C:attention}+#3#{} Consumable Slots",
            "When {C:attention}Blind{} is selected, destroy adjacent {C:attention}Jokers{} {C:red}for fun{}",
            "All {C:attention}Blinds{} are {C:attention}Showdown Boss Blinds{}",
            "Scored {C:attention}6's{} gain a permanent {C:red}Blood Stigmata{}",
            "Destroy all played cards after scoring",
            "Sacrifice your most devoted {C:red}Blood Card{} to create the",
            "{C:attention}Consumable{} of your choice",
            "{C:red}Blood Cards{} have their {C:attention}Devotion{} doubled when scored",
            "Guarantees your {C:red}Blood{} will be drawn first",
            "Increases final {C:attention}operator{} by {C:attention}+1{}",
            "{C:red,s:1.5}WILL KILL YOU{} if sold, lost, or destroyed in {C:red,s:1.5}ANY{} way",
            "{C:inactive}\"Er, our blood stigmata cards, that is...\"{}",
            "{C:inactive}(Charybdis, The Progenitor of the Frost + Aurora, The Prophesied Cataclysm){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            set = "Other",
            key = "ultrafusion_blood_stigmata",
            vars = { devotion = 1 }
        }

        return {
            vars = {
                card.ability.extra.joker_slots,
                card.ability.extra.hand_size,
                card.ability.extra.consumable_slots
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
        end
        if G.hand then
            G.hand:change_size(card.ability.extra.hand_size)
        end
        if G.consumeables and G.consumeables.config then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumable_slots
        end

        G.GAME.round_resets.blind_choices.Big = get_new_boss()
        G.GAME.round_resets.blind_choices.Small = get_new_boss()

        if UF.MODS.POLTERWORX then
            if get_final_operator then
                card.ability.extra.prev_final_operator = get_final_operator(true)
            end
            if get_final_operator_offset then
                card.ability.extra.prev_final_operator_offset = get_final_operator_offset()
            end
            if change_final_operator then
                change_final_operator(1)
                card.ability.extra.operator_applied = true
                if update_operator_display then
                    update_operator_display()
                end
            end
        else
            if SMODS.get_scoring_calculation then
                card.ability.extra.prev_scoring_calc = SMODS.get_scoring_calculation()
            end
            card.ability.extra.custom_calc_active = true
            UF.U.BLOOD.twbb_set_hand_operator('ultrafusion_uf_twbb_bloodmath')
            UF.U.BLOOD.twbb_update_operator_display()
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not UF.MODS.POLTERWORX and G and G.GAME and G.GAME.hands then
            for _, hand in pairs(G.GAME.hands) do
                hand.operator = nil
            end
        end
        UF.U.GAME_OVER()
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if UF.MODS.POLTERWORX then
                if context.before or context.joker_main or context.final_scoring_step then
                    if set_final_operator and card.ability.extra.prev_final_operator ~= nil then
                        local expected = card.ability.extra.prev_final_operator + 1
                        if get_final_operator(true) ~= expected then
                            set_final_operator(expected)
                        end
                        if update_operator_display then
                            update_operator_display()
                        end
                    end
                end
            else
                if context.before or context.joker_main or context.final_scoring_step then
                    UF.U.BLOOD.twbb_update_operator_display()
                end
            end
        end

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

                for _, other_joker in ipairs(to_destroy) do
                    other_joker.ability.eternal = nil
                    other_joker.getting_sliced = true

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            other_joker:start_dissolve(nil, true)
                            return true
                        end
                    }))
                end
            end
        end

        if context.drawing_cards and not context.blueprint then
            UF.U.BLOOD.twbb_sort_blood_first()
        end

        if context.individual
        and context.cardarea == G.play
        and context.other_card then
            local scored = context.other_card

            if scored:get_id() == 6 and not UF.U.BLOOD.has_blood_stigmata(scored) then
                scored:add_sticker("ultrafusion_blood_stigmata", true)
                scored.ability.ultrafusion_blood_stigmata.aurora_data = card.ability.extra
            end

            if UF.U.BLOOD.has_blood_stigmata(scored) then
                UF.U.BLOOD.twbb_double_devotion(scored)

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    card = scored
                }
            end
        end

        if context.destroy_card
        and context.cardarea == G.play
        and not context.blueprint then
            if UF.U.BLOOD.has_blood_stigmata(context.destroy_card) then
                return {}
            end
            return {
                remove = true
            }
        end

        -- TODO
        -- UF.U.BLOOD.twbb_sacrifice_most_devoted_for_choice(chosen_key)
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_charybdis_the_progenitor_of_the_frost" },
        { name = "j_ultrafusion_aurora_the_prophesied_cataclysm" },
    },
    result_joker = "j_ultrafusion_there_will_be_blood",
    cost = 666999666999,
}