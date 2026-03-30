SMODS.Joker {
	key = "subwoofer",

	rarity = "fusion",
	blueprint_compat = false,
	cost = 8,

	loc_txt = {
		name = "Subwoofer",
		text = {
			"{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{} and",
			"{C:spectral}Spectral{} cards may appear",
			"multiple times",
			"Played {C:attention}number{} cards give",
			"{C:blue}+10{} Chips and {C:red}+4{} Mult",
			"when scored",
			"{C:inactive}(Showman + Walkie Talkie){}"
		}
	},

	calculate = function(self, card, context)
		if context.individual
		and context.cardarea == G.play
		and context.other_card
		and context.other_card:get_id()
		and context.other_card:get_id() >= 2
		and context.other_card:get_id() <= 10 then
			return {
				chips = 10,
				mult = 4,
				card = card
			}
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_ring_master" },
		{ name = "j_walkie_talkie" },
	},
	result_joker = "j_ultrafusion_subwoofer",
	cost = 8,
}