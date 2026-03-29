SMODS.Joker {
	key = "divine_oracle",

	rarity = "ultrafusion_advfusion",
	blueprint_compat = true,
	cost = 14,

	config = {
		extra = {
			numerator = 1,
			denominator = 2,
			xmult_gain = 0.1
		}
	},

	loc_txt = {
		name = "Divine Oracle",
		text = {
			"{C:green}#1# in #2#{} chance to create a",
			"{C:tarot}Tarot{} card whenever you play a hand",
			"Create a {C:dark_edition}Negative{} {C:tarot}Fool{}",
			"whenever a {C:attention}Booster Pack{} is opened",
			"Gives {X:mult,C:white}X#4#{} Mult per",
			"{C:tarot}Tarot{} card used this run",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult){}",
			"{C:inactive}(Sage Prophet + Enlightened Seer){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		local tarots_used = 0
		for _, v in pairs(G.GAME.consumeable_usage or {}) do
			if v.set == 'Tarot' then
				tarots_used = tarots_used + (v.count or 0)
			end
		end

		local num, den = SMODS.get_probability_vars(
			card,
			card.ability.extra.numerator,
			card.ability.extra.denominator,
			"ultrafusion_divine_oracle_tarot"
		)

		return {
			vars = {
				num,
				den,
				1 + (tarots_used * card.ability.extra.xmult_gain),
				card.ability.extra.xmult_gain
			}
		}
	end,

	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if SMODS.pseudorandom_probability(
				card,
				"ultrafusion_divine_oracle_tarot",
				card.ability.extra.numerator,
				card.ability.extra.denominator,
				"ultrafusion_divine_oracle_tarot"
			) then
				G.E_MANAGER:add_event(Event({
					func = function()
						if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

							local tarot = create_card(
								'Tarot',
								G.consumeables,
								nil,
								nil,
								nil,
								nil,
								nil,
								'ultrafusion_divine_oracle_tarot'
							)

							tarot:add_to_deck()
							G.consumeables:emplace(tarot)
							G.GAME.consumeable_buffer = 0

							card_eval_status_text(card, 'extra', nil, nil, nil, {
								message = localize('k_plus_tarot'),
								colour = G.C.PURPLE
							})
						end
						return true
					end
				}))
			end
		end

		if context.open_booster and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
						G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

						local fool = create_card(
							'Tarot',
							G.consumeables,
							nil,
							nil,
							nil,
							nil,
							'c_fool',
							'ultrafusion_divine_oracle_fool'
						)

						if fool and fool.set_edition then
							fool:set_edition({ negative = true }, true, true)
						end

						if fool then
							fool:add_to_deck()
							G.consumeables:emplace(fool)

							card_eval_status_text(card, 'extra', nil, nil, nil, {
								message = localize('k_plus_tarot'),
								colour = G.C.PURPLE
							})
						end

						G.GAME.consumeable_buffer = 0
					end

					return true
				end
			}))
		end

		if context.joker_main then
			local tarots_used = 0
			for _, v in pairs(G.GAME.consumeable_usage or {}) do
				if v.set == 'Tarot' then
					tarots_used = tarots_used + (v.count or 0)
				end
			end

			return {
				xmult = 1 + (tarots_used * card.ability.extra.xmult_gain)
			}
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_sage_prophet" },
		{ name = "j_ultrafusion_enlightened_seer" },
	},
	result_joker = "j_ultrafusion_divine_oracle",
	cost = 14,
}