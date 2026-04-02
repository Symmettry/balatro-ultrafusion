SMODS.Joker {
    key = "crypto_wallet",

    rarity = "ultrafusion_advfusion",
    blueprint_compat = true,
    cost = 16,

    config = {
        extra = {
            debt_limit = 91,
            chips = 30,
            xmult = 0.3,
            dollars = 3,
            numerator = 1,
            denominator = 20
        }
    },

    loc_txt = {
        name = "Crypto Wallet",
        text = {
            "Go up to {C:red}-$#1#{} in debt",
            "For each {C:attention}Ace{}, {C:attention}2{}, {C:attention}3{}, {C:attention}5{},",
            "{C:attention}7{}, {C:attention}Jack{}, and {C:attention}King{} in your full deck,",
            "this Joker gives {C:blue}+#2#{} Chips, {X:mult,C:white}X#3#{} Mult,",
            "and {C:money}$#4#{} at end of round",
            "While at or below {C:money}$0{}, triple these amounts",
            "{C:green}#5# in #6#{} chance your money becomes {C:money}$0{}",
            "when selecting a {C:attention}Blind{}",
            "{C:inactive}(Currently {C:blue}+#7#{} Chips, {X:mult,C:white}X#8#{} Mult, {C:money}$#9#{}{C:inactive}){}",
            "{C:inactive}(Sturdy Joker + Mathematician + Cloud Banking){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                local id = playing_card:get_id()
                if id == 14 or id == 2 or id == 3 or id == 5 or id == 7 or id == 11 or id == 13 then
                    count = count + 1
                end
            end
        end

        local num, den = SMODS.get_probability_vars(
            card,
            card.ability.extra.numerator,
            card.ability.extra.denominator,
            "ultrafusion_crypto_wallet_zero"
        )

        local tripled = G.GAME and G.GAME.dollars and G.GAME.dollars <= 0
        local scalar = tripled and 3 or 1

        return {
            vars = {
                card.ability.extra.debt_limit,
                card.ability.extra.chips,
                card.ability.extra.xmult,
                card.ability.extra.dollars,
                num,
                den,
                count * card.ability.extra.chips * scalar,
                1 + count * card.ability.extra.xmult * scalar,
                count * card.ability.extra.dollars * scalar
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.GAME then
            G.GAME.bankrupt_at = -card.ability.extra.debt_limit
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.GAME then
            G.GAME.bankrupt_at = 0
        end
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if SMODS.pseudorandom_probability(
                card,
                "ultrafusion_crypto_wallet_zero",
                card.ability.extra.numerator,
                card.ability.extra.denominator,
                "ultrafusion_crypto_wallet_zero"
            ) then
                ease_dollars(-(G.GAME.dollars or 0))
                return nil, true
            end
        end

        if context.joker_main then
            local count = 0

            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    local id = playing_card:get_id()
                    if id == 14 or id == 2 or id == 3 or id == 5 or id == 7 or id == 11 or id == 13 then
                        count = count + 1
                    end
                end
            end

            local dollars = G.GAME.dollars or 0
            local scalar = dollars <= 0 and 3 or 1

            return {
                chips = count * card.ability.extra.chips * scalar,
                xmult = 1 + count * card.ability.extra.xmult * scalar
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local count = 0

            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    local id = playing_card:get_id()
                    if id == 14 or id == 2 or id == 3 or id == 5 or id == 7 or id == 11 or id == 13 then
                        count = count + 1
                    end
                end
            end

            local dollars = G.GAME.dollars or 0
            local scalar = dollars <= 0 and 3 or 1
            local payout = count * card.ability.extra.dollars * scalar

            if payout > 0 then
                return {
                    dollars = payout
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_ultrafusion_sturdy" },
        { name = "j_ultrafusion_mathematician" },
        { name = "j_ultrafusion_cloud_banking" },
    },
    result_joker = "j_ultrafusion_crypto_wallet",
    cost = 16,
}