SMODS.Joker {
    key = "antimatter_dimension",

    rarity = "fusion",
    blueprint_compat = true,
    cost = 8,

    config = {
        extra = {
            joker_slots = 1,
            xmult_per_slot = 1
        }
    },

    loc_txt = {
        name = "Antimatter Dimension",
        text = {
            "{C:attention}+#1#{} Joker Slot",
            "Gives {X:mult,C:white}X#2#{} Mult for each",
            "{C:attention}Joker Slot{} above {C:attention}4{}",
            "Retriggers itself once for",
            "each {C:attention}empty{} Joker Slot",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} and {C:attention}#4#{}{C:inactive} retriggers){}",
            "{C:inactive}(Invisible Joker + Joker Stencil){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local slots = 0
        local filled = 0

        if G.jokers and G.jokers.config then
            slots = G.jokers.config.card_limit or 0
        end

        if G.jokers and G.jokers.cards then
            filled = #G.jokers.cards
        end

        local slots_above_4 = math.max(0, slots - 4)
        local current_xmult = 1 + (card.ability.extra.xmult_per_slot * slots_above_4)
        local current_retriggers = math.max(0, slots - filled)

        return {
            vars = {
                card.ability.extra.joker_slots,
                card.ability.extra.xmult_per_slot,
                current_xmult,
                current_retriggers
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.jokers and G.jokers.config then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local slots = 0

            if G.jokers and G.jokers.config then
                slots = G.jokers.config.card_limit or 0
            end

            local slots_above_4 = math.max(0, slots - 4)

            return {
                xmult = 1 + (card.ability.extra.xmult_per_slot * slots_above_4)
            }
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
                    repetitions = empty_slots,
                    card = card
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_invisible" },
        { name = "j_stencil" },
    },
    result_joker = "j_ultrafusion_antimatter_dimension",
    cost = 8,
}