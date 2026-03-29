SMODS.Joker {
	key = "adolescent_witch",
	rarity = "ultrafusion_advfusion",
	blueprint_compat = true,
	perishable_compat = false,
	cost = 12,
	config = {
		extra = {
			chips_per_2_sell = 15,
			mult_per_2_sell = 2,
			sell_gain_cap = 13
		}
	},
	loc_txt = {
		name = "Adolescent Witch",
		text = {
			"Scored {C:attention}Face Cards{} give",
			"{C:blue}+#1#{} Chips and {C:mult}+#2#{} Mult",
			"per {C:money}$2{} of this Joker's {C:attention}Sell Value{}",
			"When {C:attention}Blind{} is selected, destroy",
			"adjacent {C:attention}Jokers{}, bypassing {C:attention}Eternal{}",
			"Jokers destroyed this way add",
			"{C:money}1/2{} their {C:attention}Sell Value{} to",
			"this Joker's {C:attention}Sell Value{}",
			"Cannot change {C:attention}Sell Value{} more than {C:money}$#3#{} at once",
			"{C:inactive}(Currently {C:blue}+#4#{} {C:inactive}Chips and {C:mult}+#5#{} {C:inactive}Mult)",
			"{C:inactive}(Young Cultist + Uncanny Face){}"
		}
	},
	loc_vars = function(self, info_queue, card)
		local sell_value = (card and card.sell_cost) or 0
		local steps = math.floor(sell_value / 2)
		local chips = steps * card.ability.extra.chips_per_2_sell
		local mult = steps * card.ability.extra.mult_per_2_sell

		return {
			vars = {
				card.ability.extra.chips_per_2_sell,
				card.ability.extra.mult_per_2_sell,
				card.ability.extra.sell_gain_cap,
				chips,
				mult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					if not G.jokers or not G.jokers.cards then
						return true
					end

					local my_index = nil
					for i, j in ipairs(G.jokers.cards) do
						if j == card then
							my_index = i
							break
						end
					end

					if not my_index then
						return true
					end

					local to_destroy = {}
					local left = G.jokers.cards[my_index - 1]
					local right = G.jokers.cards[my_index + 1]

					if left and left ~= card then
						to_destroy[#to_destroy + 1] = left
					end
					if right and right ~= card then
						to_destroy[#to_destroy + 1] = right
					end

					if #to_destroy == 0 then
						return true
					end

					local total_gain = 0

					for _, destroyed in ipairs(to_destroy) do
						local destroyed_sell = destroyed.sell_cost or 0
						total_gain = total_gain + (destroyed_sell / 2)

						if destroyed.start_dissolve then
							destroyed:start_dissolve()
						end
					end

					local cap = card.ability.extra.sell_gain_cap
					total_gain = math.max(-cap, math.min(cap, total_gain))

					if total_gain ~= 0 then
						card.ability.extra_value = (card.ability.extra_value or 0) + total_gain
						card:set_cost()

						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = localize('k_val_up'),
							colour = total_gain >= 0 and G.C.MONEY or G.C.RED
						})
					end

					return true
				end
			}))
			return nil, true
		end

		if context.individual and context.cardarea == G.play and context.other_card then
			if context.other_card:is_face() then
				local sell_value = card.sell_cost or 0
				local steps = math.floor(sell_value / 2)
				local chips = steps * card.ability.extra.chips_per_2_sell
				local mult = steps * card.ability.extra.mult_per_2_sell

				return {
					chips = chips,
					mult = mult
				}
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_young_cultist" },
		{ name = "j_fuse_uncanny_face" },
	},
	result_joker = "j_ultrafusion_adolescent_witch",
	cost = 12,
}