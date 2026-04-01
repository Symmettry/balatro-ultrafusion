SMODS.Joker {
    key = "aurora_the_prophesied_cataclysm",

    rarity = "ultrafusion_legfusion",
    cost = 666,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,

    config = {
        extra = {
            blood = 0.2,
            min_blood = 0.2,
            max_blood = 999
        }
    },

    loc_txt = {
        name = "{C:red}Aurora, The Prophesised Cataclysm{}",
        text = {
            "{C:inactive}Hope you like what I did with all her high quality blood~!{}",
            "{C:red}🩸#1#{} / {C:red}#2#🍷{}",
            "All {C:attention}Blinds{} are {C:attention}Boss Blinds{}",
            "When {C:attention}Blind{} is selected, destroy adjacent {C:attention}Jokers{}",
            "and gain {C:red}🩸Blood{} from their {C:attention}Rarity{}",
            "All operations of {C:blue}Chips{}, {C:red}Mult{}, {X:mult,C:white}XMult{},",
            "and {X:chips,C:white}XChips{} are multiplied by",
            "{C:red}🩸Blood{} x this Joker's sell value",
            "{C:red,s:1.5}WILL KILL YOU{} if sold, lost, or destroyed in {C:red,s:1.5}ANY{} way",
            "Played cards are {C:attention}Cleansed{}, but have a fixed {C:red}95%{} chance to die",
            "If they survive, they gain a permanent {C:red}Blood Stigmata{} sticker",
            "{C:inactive}(Ex: Converts Chips+10 into Chips+(10*#3#))",
            "{C:inactive}(The Dauntless Sojourner + The Blood Witch){}"
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
                card.ability.extra.blood,
                card.ability.extra.max_blood,
                card.ability.extra.blood * card.sell_cost
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        card.sell_cost = 333

        if G.P_BLINDS[G.GAME.round_resets.blind_choices.Big]
        and G.P_BLINDS[G.GAME.round_resets.blind_choices.Big].boss then
            return
        end

        G.GAME.round_resets.blind_choices.Big = get_new_boss()
        G.GAME.round_resets.blind_choices.Small = get_new_boss()
    end,

    remove_from_deck = function(self, card, from_debuff)
        if next(SMODS.find_card("j_ultrafusion_charybdis_the_progenitor_of_the_frost")) then return end
        UF.U.GAME_OVER()
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card:add_sticker("eternal", true)
    end,

    calculate = function(self, card, context)
        -- =========================================================
        -- Kill adjacent jokers + gain blood
        -- =========================================================
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
                end
            end
        end

        -- =========================================================
        -- Played cards: 95% death
        -- =========================================================
        if context.destroy_card
        and context.cardarea == G.play
        and not context.blueprint
        and context.destroy_card then
            local numerator, denominator = 19, 20
            local roll = pseudorandom(pseudoseed("aurora_card_death"))
            local kill = roll < (numerator / denominator)

            if not card.ability.ultrafusion_blood_stigmata and kill then
                return { remove = true }
            else
                local c = context.destroy_card
                c:add_sticker("ultrafusion_blood_stigmata", true)
                c.ability.ultrafusion_blood_stigmata.aurora_data = card.ability.extra
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_the_dauntless_sojourner" },
        { name = "j_ultrafusion_blood_witch" },
    },
    result_joker = "j_ultrafusion_aurora_the_prophesied_cataclysm",
    cost = 888,
}