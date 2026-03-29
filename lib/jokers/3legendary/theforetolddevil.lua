SMODS.Joker {
	key = "the_foretold_devil",

	rarity = "legfusion",
	blueprint_compat = true,
	cost = 24,

	config = {
		extra = {
			slots = 3
		}
	},

	loc_txt = {
		name = "The Foretold Devil",
		text = {
			"{C:inactive}\"I'm telling you, this is NOT the devil I spoke of! Why won't you LISTEN to me?!\"{}",
			"{C:attention}+#2#{} Consumable Slots",
			"Each of the following effects has a {C:green}#1# in 2{} chance to trigger:",
			"If played hand contains an {C:attention}8{}, create a {C:tarot}Tarot{} card",
			"If played hand contains a {C:attention}6{}, create a {C:spectral}Spectral{} card",
			"If played hand is a {C:attention}Straight{} containing a {C:attention}6{} or an {C:attention}8{}, create a",
			"{C:dark_edition}Negative{} copy of the leftmost {C:attention}consumeable{}",
			"All effects are guaranteed if played hand",
			"is a {C:attention}Straight{} containing a {C:attention}6{} and an {C:attention}8{}",
			"{C:inactive}(Divine Oracle + Demonic Ritual + Perkeo){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1,
				card.ability.extra.slots
			}
		}
	end,

	add_to_deck = function(self, card, from_debuff)
		if G.consumeables and G.consumeables.config then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
		end
	end,

	remove_from_deck = function(self, card, from_debuff)
		if G.consumeables and G.consumeables.config then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
		end
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
			local straight_has_6_or_8 = is_straight and (sixes > 0 or eights > 0)
			local guaranteed = is_straight and sixes > 0 and eights > 0
			local odds = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1) / 2

			local make_tarot = eights > 0 and (guaranteed or pseudorandom('ultrafusion_foretold_devil_tarot') < odds)
			local make_spectral = sixes > 0 and (guaranteed or pseudorandom('ultrafusion_foretold_devil_spectral') < odds)
			local make_copy = straight_has_6_or_8 and (guaranteed or pseudorandom('ultrafusion_foretold_devil_copy') < odds)

			if make_tarot then
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
								'ultrafusion_foretold_devil_tarot'
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

			if make_spectral then
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
								'ultrafusion_foretold_devil_spectral'
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

			if make_copy then
				G.E_MANAGER:add_event(Event({
					func = function()
						local source = G.consumeables and G.consumeables.cards and G.consumeables.cards[1]

						if source then
							local copied = copy_card(source, nil)
							if copied then
								if copied.set_edition then
									copied:set_edition({ negative = true }, true, true)
								end

								copied:add_to_deck()
								G.consumeables:emplace(copied)

								card_eval_status_text(card, 'extra', nil, nil, nil, {
									message = localize('k_copied_ex'),
									colour = G.C.DARK_EDITION
								})
							end
						end
						return true
					end
				}))
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_divine_oracle" },
		{ name = "j_ultrafusion_demonic_ritual" },
		{ name = "j_perkeo" },
	},
	result_joker = "j_ultrafusion_the_foretold_devil",
	cost = 24,
}