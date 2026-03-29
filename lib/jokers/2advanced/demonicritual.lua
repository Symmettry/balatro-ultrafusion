SMODS.Joker {
	key = "demonic_ritual",

	rarity = "advfusion",
	blueprint_compat = true,
	cost = 14,

	loc_txt = {
		name = "Demonic Ritual",
		text = {
			"If played hand contains exactly {C:attention}one 8{},",
			"{C:green}#1# in 2{} chance to create a {C:tarot}Tarot{} card",
			"If played hand contains exactly {C:attention}one 6{},",
			"{C:green}#1# in 2{} chance to create a {C:spectral}Spectral{} card",
			"If played hand is a {C:attention}Straight{} containing",
			"a {C:attention}6{} and an {C:attention}8{}, additionally create",
			"a {C:dark_edition}Negative{} {C:spectral}Immolate{}",
			"{C:inactive}(Superstition + Summoner){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1
			}
		}
	end,

	calculate = function(self, card, context)
		if context.before and context.full_hand and not context.blueprint then
			local sixes = 0
			local eights = 0

			for _, played_card in ipairs(context.full_hand) do
				local id = played_card:get_id()
				if id == 6 then sixes = sixes + 1 end
				if id == 8 then eights = eights + 1 end
			end

			local is_straight = context.scoring_name == "Straight"
			local straight_6_8 = is_straight and sixes >= 1 and eights >= 1
			local odds = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1) / 2

			if eights == 1 and pseudorandom('ultrafusion_demonic_ritual_tarot') < odds then
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
								'ultrafusion_demonic_ritual_tarot'
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

			if sixes == 1 and pseudorandom('ultrafusion_demonic_ritual_spectral') < odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

							local spectral = create_card(
								'Spectral',
								G.consumeables,
								nil,
								nil,
								nil,
								nil,
								nil,
								'ultrafusion_demonic_ritual_spectral'
							)

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
			end

			if straight_6_8 then
				G.E_MANAGER:add_event(Event({
					func = function()
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                        local immolate = create_card(
                            'Spectral',
                            G.consumeables,
                            nil,
                            nil,
                            nil,
                            nil,
                            'c_immolate',
                            'ultrafusion_demonic_ritual'
                        )

                        if immolate and immolate.set_edition then
                            immolate:set_edition({ negative = true }, true, true)
                        end

                        immolate:add_to_deck()
                        G.consumeables:emplace(immolate)
                        G.GAME.consumeable_buffer = 0

                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_spectral'),
                            colour = G.C.SECONDARY_SET.Spectral
                        })
						return true
					end
				}))
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_superstition" },
		{ name = "j_ultrafusion_summoner" },
	},
	result_joker = "j_ultrafusion_demonic_ritual",
	cost = 14,
}