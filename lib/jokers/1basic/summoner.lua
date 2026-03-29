SMODS.Joker {
	key = "summoner",

	rarity = "fusion",
	blueprint_compat = true,
	cost = 10,

	config = {
		extra = {
			dollars = 3
		}
	},

	loc_txt = {
		name = "Summoner",
		text = {
			"If played hand contains",
			"exactly {C:attention}one 6{}, create a",
			"{C:spectral}Spectral{} card, then destroy",
			"all cards in played hand and earn",
			"{C:money}$#1#{} for each card destroyed",
			"{C:inactive}(includes unscored cards){}",
			"{C:inactive}(Trading Card + Sixth Sense + Seance){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.dollars
			}
		}
	end,

	calculate = function(self, card, context)
		if context.before and context.full_hand and not context.blueprint then
			local sixes = 0
			for _, played_card in ipairs(context.full_hand) do
				if played_card:get_id() == 6 then
					sixes = sixes + 1
				end
			end

			if sixes == 1 then
				local destroyed_cards = {}
				for _, played_card in ipairs(context.full_hand) do
					destroyed_cards[#destroyed_cards + 1] = played_card
				end

				G.E_MANAGER:add_event(Event({
					func = function()
						if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
							local spectral = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'ultrafusion_summoner')
							spectral:add_to_deck()
							G.consumeables:emplace(spectral)
							G.GAME.consumeable_buffer = 0
							card_eval_status_text(card, 'extra', nil, nil, nil, {
								message = localize('k_plus_spectral'),
								colour = G.C.SECONDARY_SET.Spectral
							})
						end
						return true
					end
				}))

				G.E_MANAGER:add_event(Event({
					func = function()
						for _, destroyed_card in ipairs(destroyed_cards) do
							if destroyed_card and destroyed_card.start_dissolve then
								destroyed_card:start_dissolve()
							end
						end
						return true
					end
				}))

				return {
					dollars = #destroyed_cards * card.ability.extra.dollars
				}
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_trading" },
		{ name = "j_sixth_sense" },
		{ name = "j_seance" },
	},
	result_joker = "j_ultrafusion_summoner",
	cost = 10,
}