SMODS.Joker {
	key = "the_final_frontier",

	rarity = "ultrafusion_heroicfusion",
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	cost = 24,

	config = {
		extra = {
			known_levels = {}
		}
	},

	loc_txt = {
		name = "{C:blue}The Final Frontier{}",
		text = {
			"{C:inactive}\"Only took an entire Dyson Sphere to power the damn thing...\"{}",
			"Whenever a {C:attention}Poker Hand{} levels up, it gains {C:mult}+Mult{} equal to:",
			"{C:attention}(Times Played) X (Planets Used) X (Mult per Level) X (Discards){}",
			"Whenever a {C:attention}Poker Hand{} levels up, it gains {C:blue}+Chips{} equal to:",
			"{C:attention}(Level) X (Current Money) X (Chips per Level) X (Hands){}",
			"{C:inactive}(Dyson Sphere Project + Interstellar Warp Core){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = {}}
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.extra.known_levels = card.ability.extra.known_levels or {}

		for handname, handdata in pairs(G.GAME.hands or {}) do
			card.ability.extra.known_levels[handname] = handdata.level or 1
		end
	end,

	calculate = function(self, card, context)
		card.ability.extra.known_levels = card.ability.extra.known_levels or {}

		if not context.blueprint then
			for handname, handdata in pairs(G.GAME.hands or {}) do
				local current_level = handdata.level or 1
				local previous_level = card.ability.extra.known_levels[handname]

				if previous_level == nil then
					card.ability.extra.known_levels[handname] = current_level
				elseif current_level > previous_level then
					local level_diff = current_level - previous_level
					local played_count = handdata.played or 0

                    local planets_used = 0
                    for _, v in pairs(G.GAME.consumeable_usage or {}) do
                        if v.set == "Planet" then
                            planets_used = planets_used + (v.count or 0)
                        end
                    end

					local current_money = G.GAME.dollars or 0
					local current_round = G.GAME.current_round or {}
					local discards = current_round.discards_left or 0
					local hands = current_round.hands_left or 0

					local mult_per_level = handdata.l_mult or 0
					local chips_per_level = handdata.l_chips or 0

					local mult_gain = math.floor(
						played_count
						* planets_used
						* mult_per_level
						* discards
						* level_diff
					)

					local chips_gain = math.floor(
						current_level
						* current_money
						* chips_per_level
						* hands
						* level_diff
					)

					handdata.mult = (handdata.mult or 0) + mult_gain
					handdata.chips = (handdata.chips or 0) + chips_gain
					card.ability.extra.known_levels[handname] = current_level

					return {
						message = localize('k_upgrade_ex'),
						colour = G.C.MULT
					}
				end
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_dyson_sphere_project" },
		{ name = "j_ultrafusion_interstellar_warp_core" },
	},
	result_joker = "j_ultrafusion_the_final_frontier",
	cost = 24,
}