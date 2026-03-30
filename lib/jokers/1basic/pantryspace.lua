SMODS.Joker {
	key = "pantry_space",

	rarity = "fusion",
	blueprint_compat = false,
	cost = 8,

	config = {
		extra = {
			h_size = 5,
			odds = 5
		}
	},

	loc_txt = {
		name = "Pantry Space",
		text = {
			"{C:attention}+#1#{} hand size",
			"{C:green}#2# in #3#{} chance to revert",
			"into {C:attention}Troubadour{}",
			"at end of round",
			"{C:inactive}(Troubadour + Bean){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

		return {
			vars = {
				card.ability.extra.h_size,
				numerator,
				denominator
			}
		}
	end,

	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.h_size)
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.h_size)
	end,

	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "pantry_space_revert", true)

			if pseudorandom(pseudoseed("pantry_space_revert")) < (numerator / denominator) then
				G.E_MANAGER:add_event(Event({
					func = function()
						if card and card.area == G.jokers then
							GIVE_JOKER("j_troubadour")
							card:start_dissolve()
						end
						return true
					end
				}))

				return {
					message = localize('k_plus_joker'),
					colour = G.C.GREEN
				}
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_troubadour" },
		{ name = "j_turtle_bean" },
	},
	result_joker = "j_ultrafusion_pantry_space",
	cost = 8,
}