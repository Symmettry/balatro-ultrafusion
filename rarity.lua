SMODS.Rarity {
    key = "advfusion",
    loc_txt = { name = "Advanced Fusion" },
    badge_colour = HEX("f28f15"),
    text_colour = HEX("FFFFFF"),
    disable_if_empty = false,
    weight = 0,
	pools = {["Joker"] = false},
	get_weight = function(self, weight, object_type)
			return weight
	end,
}

SMODS.Rarity {
    key = "legfusion",
    loc_txt = { name = "Legendary Fusion" },
    badge_colour = HEX("36b43b"),
    text_colour = HEX("FFFFFF"),
    disable_if_empty = false,
    weight = 0,
	pools = {["Joker"] = false},
	get_weight = function(self, weight, object_type)
			return weight
	end,
}

SMODS.Rarity {
    key = "ultfusion",
    loc_txt = { name = "Ultimate Fusion" },
    badge_colour = HEX("0e6780"),
    text_colour = HEX("FFFFFF"),
    disable_if_empty = false,
    weight = 0,
	pools = {["Joker"] = false},
	get_weight = function(self, weight, object_type)
			return weight
	end,
}