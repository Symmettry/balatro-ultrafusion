SMODS.Joker {
	key = "dyson_sphere_project",

	rarity = "ultrafusion_advfusion",
	blueprint_compat = true,
	perishable_compat = false,
	cost = 16,

	config = {
		extra = {
			dollars_per_unit = 5,
			chips = 50,
			mult = 5,
			dollars = 2,
			scalar = 1
		}
	},

	loc_txt = {
		name = "Dyson Sphere Project",
		text = {
			"For every {C:money}$#1#{} you have, this Joker gives {C:blue}+#2#{} Chips,",
			"{C:mult}+#3#{} Mult, and {C:money}$#4#{} at end of round",
			"{C:planet}+100%{} to these values whenever a {C:planet}Planet{} card is used",
			"{C:inactive}(Currently {C:blue}+#5#{} Chips, {C:mult}+#6#{} Mult, and {C:money}$#7#{}{C:inactive} per {C:money}$#1#{}{C:inactive}){}",
			"{C:inactive}(Moon Landing + Cowboy + Space Station){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		local scalar = card.ability.extra.scalar or 1
		return {
			vars = {
				card.ability.extra.dollars_per_unit,
				card.ability.extra.chips,
				card.ability.extra.mult,
				card.ability.extra.dollars,
				card.ability.extra.chips * scalar,
				card.ability.extra.mult * scalar,
				card.ability.extra.dollars * scalar
			}
		}
	end,

	calculate = function(self, card, context)
		if context.using_consumeable
		and context.consumeable
		and context.consumeable.ability
		and context.consumeable.ability.set == "Planet"
		and not context.blueprint then
			card.ability.extra.scalar = (card.ability.extra.scalar or 1) * 2
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MONEY
			}
		end

		if context.joker_main then
			local dollars = G.GAME.dollars or 0
			local units = math.floor(dollars / card.ability.extra.dollars_per_unit)
			local scalar = card.ability.extra.scalar or 1

			return {
				chips = units * card.ability.extra.chips * scalar,
				mult = units * card.ability.extra.mult * scalar
			}
		end

		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local dollars = G.GAME.dollars or 0
			local units = math.floor(dollars / card.ability.extra.dollars_per_unit)
			local scalar = card.ability.extra.scalar or 1
			local payout = units * card.ability.extra.dollars * scalar

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
		{ name = "j_ultrafusion_moon_landing" },
		{ name = "j_ultrafusion_cowboy" },
		{ name = "j_ultrafusion_space_station" },
	},
	result_joker = "j_ultrafusion_dyson_sphere_project",
	cost = 16,
}