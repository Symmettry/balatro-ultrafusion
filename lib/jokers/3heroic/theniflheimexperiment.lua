SMODS.Joker {
    key = "the_niflheim_experiment",

    rarity = "ultrafusion_heroicfusion",
    blueprint_compat = true,
    cost = 24,

    config = {
        extra = {
            joker_slots = 4,
            h_size = 6,
            xmult = 8,
            chips = 125,
            mult = 25
        }
    },

    loc_txt = {
        name = "{C:blue}The Niflheim Experiment{}",
        text = {
            "{C:inactive}\"Anyone else startin' ta think this mighta been a bad idea?\"{}",
            "{C:attention}+#1#{} Joker Slots and {C:attention}+#2#{} hand size",
            "Gives a constant {X:mult,C:white}X#3#{} Mult bonus",
            "For each card below {C:attention}#6#{} remaining in your deck,",
            "scored cards give {C:blue}+#4#{} Chips and {C:red}+#5#{} Mult",
            "Copies the effects of all Jokers to the {C:attention}right{}",
            "Retriggers itself {C:attention}three{} times for each empty Joker Slot",
            "Creates a {C:attention}Double Tag{} at end of every round",
            "{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{} and {C:spectral}Spectral{} cards may appear {C:attention}multiple times{}.",
            "{C:inactive}(Currently{} {C:blue}+#7#{} {C:inactive}Chips,{} {C:red}+#8#{} {C:inactive}Mult, and {}{C:attention}#9#{} {C:inactive}retriggers){}",
            "{C:inactive}(Engineer + Pocket Dimension + Box of Frost){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local init = (G.GAME and G.GAME.starting_deck_size or 52)
        local current_deck = (G.playing_cards and #G.playing_cards or init)
        local missing_cards = math.max(0, init - current_deck)

        local slots = 0
        local filled = 0

        if G.jokers and G.jokers.config then
            slots = G.jokers.config.card_limit or 0
        end

        if G.jokers and G.jokers.cards then
            filled = #G.jokers.cards
        end

        local current_retriggers = math.max(0, slots - filled) * 3

        return {
            vars = {
                card.ability.extra.joker_slots,
                card.ability.extra.h_size,
                card.ability.extra.xmult,
                card.ability.extra.chips,
                card.ability.extra.mult,
                init,
                card.ability.extra.chips * missing_cards,
                card.ability.extra.mult * missing_cards,
                current_retriggers
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
        end
        if G.hand then
            G.hand:change_size(card.ability.extra.h_size)
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
        end
        if G.hand then
            G.hand:change_size(-card.ability.extra.h_size)
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.individual
        and context.cardarea == G.play
        and context.other_card then
            local init = G.GAME.starting_deck_size
            local missing_cards = math.max(0, init - #G.playing_cards)

            if missing_cards > 0 then
                return {
                    chips = card.ability.extra.chips * missing_cards,
                    mult = card.ability.extra.mult * missing_cards,
                    card = card
                }
            end
        end

        if context.retrigger_joker_check
        and not context.retrigger_joker
        and context.other_card == card then
            local slots = 0
            local filled = 0

            if G.jokers and G.jokers.config then
                slots = G.jokers.config.card_limit or 0
            end

            if G.jokers and G.jokers.cards then
                filled = #G.jokers.cards
            end

            local empty_slots = math.max(0, slots - filled)

            if empty_slots > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = empty_slots * 3,
                    card = card
                }
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag(Tag('tag_double'))
                    return true
                end
            }))

            return {
                message = "Double Tag!",
                colour = G.C.GREEN
            }
        end

        local ret = nil

        if G.jokers and G.jokers.cards then
            local found_self = false

            for i = 1, #G.jokers.cards do
                local other = G.jokers.cards[i]

                if other == card then
                    found_self = true
                elseif found_self then
                    local next_ret = SMODS.blueprint_effect(card, other, context)
                    ret = UF.U.merge_joker_effects(ret, next_ret)
                end
            end
        end

        if ret then
            ret.colour = G.C.BLUE
        end

        return ret
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_engineer" },
        { name = "j_ultrafusion_pocket_dimension" },
        { name = "j_ultrafusion_box_of_frost" },
    },
    result_joker = "j_ultrafusion_the_niflheim_experiment",
    cost = 24,
}