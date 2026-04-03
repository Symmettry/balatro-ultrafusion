SMODS.Joker {
    key = "renowned_poet",
    
    -- atlas = "jokers_71x95"",
    -- pos = { x = 2, y = 0 },

    rarity = "fusion",
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            mult = 0,
            mult_gain = 4,
            chips = 0,
            chips_gain = 16,
            xmult = 1,
            xmult_gain = 0.2
        }
    },

    loc_txt = {
        name = "Renowned Poet",
        text = {
            "Each discarded {C:diamonds}Diamond{} permanently grants this Joker {C:mult}+#2# Mult{}",
            "Each discarded {C:clubs}Club{} permanently grants this Joker {C:blue}+#4# Chips{}",
            "Each discarded {C:spades}Spade{} or {C:hearts}Heart{} permanently grants this Joker {X:mult,C:white}X#6#{} Mult",
            "{C:inactive}(Currently {C:mult}+#1# Mult{}, {C:blue}+#3# Chips{}, {X:mult,C:white}X#5#{} Mult{C:inactive}){}",
            "{C:inactive}(Castle + Merry Andy + Yorick){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_gain,
                card.ability.extra.chips,
                card.ability.extra.chips_gain,
                card.ability.extra.xmult,
                card.ability.extra.xmult_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card and not context.blueprint then
            local other = context.other_card
            local upgraded = false
            local colour = nil

            if other:is_suit("Diamonds") then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                upgraded = true
                colour = G.C.MULT
            end

            if other:is_suit("Clubs") then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                upgraded = true
                colour = G.C.CHIPS
            end

            if other:is_suit("Spades") or other:is_suit("Hearts") then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                upgraded = true
                colour = G.C.RED
            end

            if upgraded then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = colour
                }
            end
        end

        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_castle" },
        { name = "j_merry_andy" },
        { name = "j_yorick" },
    },
    result_joker = "j_ultrafusion_renowned_poet",
    cost = 10,
}