SMODS.Joker {
	key = "box_of_frost",

	rarity = "ultrafusion_advfusion",
	blueprint_compat = true,
	cost = 14,

	config = {
		extra = {
			chips = 125,
			mult = 25,
			xmult = 3,
			h_size = 5,
			odds = 2
		}
	},

	loc_txt = {
		name = "Box of Frost",
		text = {
			"{C:blue}+#1#{} Chips, {C:red}+#2#{} Mult, {X:mult,C:white}X#3#{} Mult, {C:attention}+#4#{} hand size",
			"{C:green}#5# in #6#{} chance to create",
			"a {C:attention}Double Tag{} at end of round",
			"{C:inactive}(Munchies + Pantry Space + Keep Your Cool){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.mult,
				card.ability.extra.xmult,
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
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
				xmult = card.ability.extra.xmult
			}
		end

		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "box_of_frost_tag", true)

			if pseudorandom(pseudoseed("box_of_frost_tag")) < (numerator / denominator) then
				G.E_MANAGER:add_event(Event({
					func = function()
						add_tag(Tag('tag_double'))
						return true
					end
				}))

				return {
					message = localize('k_tag_ex'),
					colour = G.C.GREEN
				}
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_munchies" },
		{ name = "j_ultrafusion_pantry_space" },
		{ name = "j_ultrafusion_keep_your_cool" },
	},
	result_joker = "j_ultrafusion_box_of_frost",
	cost = 14,
}