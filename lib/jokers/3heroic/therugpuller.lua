SMODS.Joker {
	key = "the_rugpuller",

	rarity = "heroicfusion",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	cost = 24,

	config = {
		extra = {
			free = 3,
			debt_limit = 333,
			chips = 30,
			chips_gain = 30,
			mult = 3,
			mult_gain = 3,
			xmult = 0.3,
			xmult_gain = 0.3,
			dollars = 3,
			dollars_gain = 3,
			odds = 4
		}
	},

	loc_txt = {
		name = "The Rugpuller",
		text = {
			"{C:inactive}\"YO BRO BUY MY NEW COIN $BAL I COPIED THE LINK TO YOUR CLIPBOARD\"{}",
			"{C:attention}#1#{} free {C:attention}Rerolls{} per shop and go up to {C:red}-$#2#{} in debt",
			"For each card of your most common {C:attention}rank{} in your full deck,",
			"other {C:attention}Jokers{} give {C:blue}+#3#{} Chips, {C:mult}+#4#{} Mult, {X:mult,C:white}X#5#{} Mult, and earn {C:money}$#6#{} at end of round",
			"Increase these amounts by {C:attention}+100%{} every time the shop is rerolled while you are below {C:red}-$100{}",
			"{C:inactive}(Does NOT!! have a {C:green}#7# in #8#{}{C:inactive} chance for your money to become {C:money}$0{}{C:inactive}){}",
			"{C:inactive}(Currently, other Jokers give {C:blue}+#9#{} {C:inactive}Chips,{} {C:mult}+#10#{} {C:inactive}Mult,{} {X:mult,C:white}X#11#{} {C:inactive}Mult, and{} {C:money}$#12#{}{C:inactive} every round){}",
			"{C:inactive}(Crypto Wallet + NFT){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		local rank_counts = {}
		local count = 0

		if G.playing_cards then
			for _, playing_card in ipairs(G.playing_cards) do
				local id = playing_card:get_id()
				rank_counts[id] = (rank_counts[id] or 0) + 1
			end
		end

		for _, v in pairs(rank_counts) do
			if v > count then
				count = v
			end
		end

		return {
			vars = {
				card.ability.extra.free,
				card.ability.extra.debt_limit,
				card.ability.extra.chips,
				card.ability.extra.mult,
				card.ability.extra.xmult,
				card.ability.extra.dollars,
				G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1,
				card.ability.extra.odds,
				count * card.ability.extra.chips,
				count * card.ability.extra.mult,
				1 + count * card.ability.extra.xmult,
				count * card.ability.extra.dollars
			}
		}
	end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            love.system.setClipboardText("https://bitly.com/98K8eH")
            G.GAME.current_round.free_rerolls = (G.GAME.current_round.free_rerolls or 0) + card.ability.extra.free
            G.GAME.bankrupt_at = -card.ability.extra.debt_limit
            calculate_reroll_cost(true)
        end
    end,

	remove_from_deck = function(self, card, from_debuff)
		G.GAME.current_round.free_rerolls = math.max((G.GAME.current_round.free_rerolls or 0) - card.ability.extra.free, 0)
		if G.GAME then
			G.GAME.bankrupt_at = 0
		end
		calculate_reroll_cost(true)
	end,

	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint then
			G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls or 0
			G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.free
			calculate_reroll_cost(true)
		end

		if context.setting_blind and not context.blueprint then
			local odds = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1) / card.ability.extra.odds

			if pseudorandom('ultrafusion_the_rugpuller_zero') < odds then
				ease_dollars(-(G.GAME.dollars or 0))
				return nil, true
			end
		end

		if context.reroll_shop and not context.blueprint then
			local dollars = G.GAME.dollars or 0

			if dollars < -100 then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
				card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollars_gain

				G.E_MANAGER:add_event(Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = localize('k_upgrade_ex'),
							colour = G.C.RED
						})
						return true
					end
				}))
			end
		end

		if context.other_joker and context.other_joker ~= card then
			local rank_counts = {}
			local count = 0

			if G.playing_cards then
				for _, playing_card in ipairs(G.playing_cards) do
					local id = playing_card:get_id()
					rank_counts[id] = (rank_counts[id] or 0) + 1
				end
			end

			for _, v in pairs(rank_counts) do
				if v > count then
					count = v
				end
			end

			return {
				chips = count * card.ability.extra.chips,
				mult = count * card.ability.extra.mult,
				xmult = 1 + count * card.ability.extra.xmult
			}
		end

		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local rank_counts = {}
			local count = 0

			if G.playing_cards then
				for _, playing_card in ipairs(G.playing_cards) do
					local id = playing_card:get_id()
					rank_counts[id] = (rank_counts[id] or 0) + 1
				end
			end

			for _, v in pairs(rank_counts) do
				if v > count then
					count = v
				end
			end

			local payout = count * card.ability.extra.dollars

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
		{ name = "j_ultrafusion_crypto_wallet" },
		{ name = "j_ultrafusion_nft" },
	},
	result_joker = "j_ultrafusion_the_rugpuller",
	cost = 24,
}