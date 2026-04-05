SMODS.Joker {
    key = "space_station",
    unlocked = false,
    blueprint_compat = false,
    rarity = "fusion",
    cost = 8,

    config = {
        extra = {
            dollars = 2
        }
    },

    loc_txt = {
        name = "Space Station",
        text = {
            "All {C:planet}Planet{} cards and {C:planet}Celestial Packs{} in the shop are free",
            "Earn {C:money}$#1#{} whenever a {C:planet}Planet{} card is used",
            "{C:inactive}(Astronomer + Satellite){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.using_consumeable
        and context.consumeable
        and context.consumeable.ability
        and context.consumeable.ability.set == "Planet" then
            return {
                dollars = card.ability.extra.dollars
            }
        end
    end
}

FusionJokers.fusions:register_fusion{
    jokers = {
        { name = "j_astronomer" },
        { name = "j_satellite" },
    },
    result_joker = "j_ultrafusion_space_station",
    cost = 8,
}