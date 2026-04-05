SMODS.Joker {
    key = "charybdis_the_progenitor_of_the_frost",

    rarity = "ultrafusion_legfusion",
    blueprint_compat = false,
    cost = 36,

    config = {
        extra = {
            joker_slots = 6,
            hand_size = 6,
            consumable_slots = 6,
            perma_gain = 666,
            copies = 6,
            random_copies = 6
        }
    },

    loc_txt = {
        name = "{C:blue}Charybdis, The Progenitor of the Frost{}",
        text = {
            "{C:inactive}You puny mortals will ALL know suffering.{}",
            "{C:attention}+#1#{} Joker Slots, {C:attention}+#2#{} Hand Size,",
            "and {C:attention}+#3#{} Consumable Slots",
            "Scored cards permanently gain {C:blue}+#4#{} Chips and",
            "{C:red}+#4#{} Mult for each {C:attention}Joker Slot{}",
            "When hand is played, create {C:attention}#5#{} {C:dark_edition}Negative{}",
            "copies of the leftmost consumable",
            "If played hand is exactly {C:attention}three 6's{}, create",
            "{C:attention}#6#{} truly random consumables",
            "{C:inactive}Capable of temporarily freezing the witch{}",
            "{C:inactive}\"It just ain't natural!\"{}",
            "{C:inactive}(The Niflheim Experiment + The Foretold Devil){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.joker_slots,
                card.ability.extra.hand_size,
                card.ability.extra.consumable_slots,
                card.ability.extra.perma_gain,
                card.ability.extra.copies,
                card.ability.extra.random_copies
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
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
        end
        if G.hand then
            G.hand:change_size(-card.ability.extra.hand_size)
        end
        if G.consumeables and G.consumeables.config then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumable_slots
        end
    end,

    calculate = function(self, card, context)
        if context.individual
        and context.cardarea == G.play
        and context.other_card then
            local joker_slots = 0
            if G.jokers and G.jokers.config then
                joker_slots = G.jokers.config.card_limit or 0
            end

            local gain = card.ability.extra.perma_gain * joker_slots
            UF.U.add_perma_bonus(context.other_card, gain)
            UF.U.add_perma_mult(context.other_card, gain)

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.BLUE,
                card = card
            }
        end

        if context.before and not context.blueprint then
            local leftmost_consumable = nil

            if G.consumeables and G.consumeables.cards and #G.consumeables.cards > 0 then
                leftmost_consumable = G.consumeables.cards[1]
            end

            if leftmost_consumable and G.consumeables and G.consumeables.config then
                local copies_to_make = card.ability.extra.copies
                for i = 1, copies_to_make do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if not leftmost_consumable then return true end

                            local new_card = copy_card(leftmost_consumable, nil, nil, G.playing_card)
                            if new_card then
                                new_card:set_edition({ negative = true }, true)
                                new_card:add_to_deck()
                                G.consumeables:emplace(new_card)
                            end
                            return true
                        end
                    }))
                end
            end

            local function hand_is_exactly_three_sixes()
                if not context.full_hand or #context.full_hand ~= 3 then
                    return false
                end

                for _, playing_card in ipairs(context.full_hand) do
                    if playing_card:get_id() ~= 6 then
                        return false
                    end
                end

                return true
            end

            if hand_is_exactly_three_sixes() and G.consumeables and G.consumeables.config then
                local all_consumables = {}

                for k, v in pairs(G.P_CENTERS) do
                    if type(v) == "table"
                    and v.set
                    and (
                        v.set == "Tarot"
                        or v.set == "Planet"
                        or v.set == "Spectral"
                        or v.set == "Consumeable"
                    ) then
                        all_consumables[#all_consumables + 1] = k
                    end
                end

                local copies_to_make = card.ability.extra.random_copies
                for i = 1, copies_to_make do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if #all_consumables == 0 then return true end

                            local idx = pseudorandom(
                                pseudoseed("charybdis_random_consumable_" .. tostring(i)),
                                1,
                                #all_consumables
                            )

                            local key = all_consumables[idx]
                            if not key then return true end

                            local new_card = create_card(
                                G.P_CENTERS[key].set,
                                G.consumeables,
                                nil,
                                nil,
                                nil,
                                nil,
                                key
                            )

                            if new_card then
                                new_card:add_to_deck()
                                G.consumeables:emplace(new_card)
                            end
                            return true
                        end
                    }))
                end

                if copies_to_make > 0 then
                    return {
                        message = "666",
                        colour = G.C.PURPLE,
                        card = card
                    }
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_the_niflheim_experiment" },
        { name = "j_ultrafusion_the_foretold_devil" },
    },
    result_joker = "j_ultrafusion_charybdis_the_progenitor_of_the_frost",
    cost = 666,
}