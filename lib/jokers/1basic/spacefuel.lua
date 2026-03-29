SMODS.Joker {
	key = "space_fuel",

	rarity = "fusion",
	blueprint_compat = true,
	perishable_compat = false,
	cost = 10,

	config = {
		extra = {
			xmult_gain = 0.2,
			level_gain = 2
		}
	},

	loc_txt = {
		name = "Space Fuel",
		text = {
			"The first played {C:attention}poker hand{}",
			"each round gains {C:attention}#2#{} levels",
			"if it's your most played hand",
			"Gives {X:mult,C:white}X#1#{} Mult per time",
			"that {C:attention}poker hand{} has been played",
			"{C:inactive}(Burnt Joker + Space Joker + Obelisk){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_gain,
				card.ability.extra.level_gain
			}
		}
	end,

	calculate = function(self, card, context)
		if context.before and context.scoring_name and not context.blueprint then
			local current_round = G.GAME.current_round or {}
			local is_first_hand = (current_round.hands_played or 0) == 0

			if is_first_hand then
				local played_hand = context.scoring_name
				local played_data = G.GAME.hands[played_hand]
				local played_count = played_data and played_data.played or 0
				local is_most_played = true

				for handname, handdata in pairs(G.GAME.hands) do
					if SMODS.is_poker_hand_visible(handname)
					and handname ~= played_hand
					and handdata.played > played_count then
						is_most_played = false
						break
					end
				end

				if is_most_played and level_up_hand then
					level_up_hand(card, played_hand, nil, card.ability.extra.level_gain)
					return {
						message = localize('k_upgrade_ex'),
						colour = G.C.MONEY
					}
				end
			end
		end

		if context.joker_main and context.scoring_name then
			local hand_data = G.GAME.hands[context.scoring_name]
			local played_count = hand_data and hand_data.played or 0
			local xmult = 1 + (played_count * card.ability.extra.xmult_gain)

			return {
				xmult = xmult
			}
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_burnt" },
		{ name = "j_space" },
		{ name = "j_obelisk" },
	},
	result_joker = "j_ultrafusion_space_fuel",
	cost = 10,
}