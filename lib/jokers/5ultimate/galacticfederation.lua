SMODS.Joker {
	key = "the_galactic_federation",

	rarity = "ultfusion",
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	cost = 40,

    config = {
        extra = {
            hands = 100,
            free = 100,

            gold_dollars = 10,
            gold_dollars_gain = 10,

            gold_xchips = 10,
            gold_xchips_gain = 10,

            yorbillion = 1000000000,
        }
    },

	loc_txt = {
		name = "The Galactic Federation",
		text = {
			"{C:inactive}\"Our final stand against the witch.\"{}",
			"{C:blue}+#1#{} Hands, {C:attention}No Debt Limit{}, and {C:attention}#2#{} free {C:attention}Rerolls{} per shop",
			"{C:attention}Gold Cards{} are {C:attention}Kings{} of every suit and are forced to score {C:attention}five{} times",
			"Gives {X:mult,C:white}X(Balance^10){} or {X:chips,C:white}X(Debt^10){}",
			"When scored, {C:attention}Gold Cards{} give {C:money}$#3#{} and {X:chips,C:white}X#4#{} Chips",
			"{C:inactive}(Increased by +100% whenever the shop is rerolled){}",
			"{C:inactive}(Triples this scaling rate at the start of each Ante){}",
			"{C:inactive}(Currently gains +$#5# and +X#6# Chips per reroll){}",
			"{C:inactive}also i gave your poker hands several more chips!!!{}",
			"{C:inactive}arcturus showed me how to turn on the warp drive LOL{}",
			"{C:inactive}(Yorb, The Galactic Menace + Midas, The Invisible Hand of God + Arcturus, The High Sovereign of Mana){}"
		}
	},

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.hands,
				card.ability.extra.free,
				card.ability.extra.gold_dollars,
				card.ability.extra.gold_xchips,
				card.ability.extra.gold_dollars_gain,
				card.ability.extra.gold_xchips_gain
			}
		}
	end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.GAME.current_round.free_rerolls = (G.GAME.current_round.free_rerolls or 0) + card.ability.extra.free
            G.GAME.bankrupt_at = -1e308
            calculate_reroll_cost(true)

            local yorbillion = UF.U.one_yorbillion()
            for handname, handdata in pairs(G.GAME.hands or {}) do
                handdata.chips = (handdata.chips or 0) + yorbillion ^ (0.22 + 2 * pseudorandom(pseudoseed("yorb_" .. G.GAME.hands_played)))
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.current_round.free_rerolls = math.max((G.GAME.current_round.free_rerolls or 0) - card.ability.extra.free, 0)
        if G.GAME then
            G.GAME.bankrupt_at = 0
        end
        calculate_reroll_cost(true)
    end,

	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint then
			G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls or 0
			G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.free
			calculate_reroll_cost(true)
		end

		if context.setting_blind and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_hands_played(card.ability.extra.hands)
					SMODS.calculate_effect(
						{
							message = localize {
								type = 'variable',
								key = 'a_hands',
								vars = { card.ability.extra.hands }
							}
						},
						context.blueprint_card or card
					)
					return true
				end
			}))
			return nil, true
		end

		if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.blueprint then
			card.ability.extra.gold_dollars_gain = card.ability.extra.gold_dollars_gain * 3
			card.ability.extra.gold_xchips_gain = card.ability.extra.gold_xchips_gain * 3

			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.RED
			}
		end

		if context.reroll_shop and not context.blueprint then
			card.ability.extra.gold_dollars = card.ability.extra.gold_dollars + card.ability.extra.gold_dollars_gain
			card.ability.extra.gold_xchips = card.ability.extra.gold_xchips + card.ability.extra.gold_xchips_gain

			G.E_MANAGER:add_event(Event({
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize('k_upgrade_ex'),
						colour = G.C.RED
					})
					return true
				end
			}))
		end

		if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
			local is_gold = context.other_card.config
				and context.other_card.config.center == G.P_CENTERS.m_gold

			if is_gold then
				return {
					dollars = card.ability.extra.gold_dollars,
					xchips = card.ability.extra.gold_xchips
				}
			end
		end

		if context.repetition and context.cardarea == G.play and context.other_card and not context.blueprint then
			local is_gold = context.other_card.config
				and context.other_card.config.center == G.P_CENTERS.m_gold

			if is_gold then
				return {
					repetitions = 4
				}
			end
		end

		if context.joker_main then
			local dollars = G.GAME and G.GAME.dollars or 0
            
			if dollars >= 0 then
				return {
					xmult = dollars ^ 10
				}
			else
				return {
					xchips = (-dollars) ^ 10
				}
			end
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ultrafusion_yorb_galactic_menace" },
		{ name = "j_ultrafusion_midas_the_invisible_hand_of_god" },
		{ name = "j_ultrafusion_arcturus_high_sovereign_of_mana" },
	},
	result_joker = "j_ultrafusion_the_galactic_federation",
	cost = 100000,
}