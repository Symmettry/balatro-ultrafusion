local GET_RAR = function (requested, fallback, mod)
    return HAS_MOD(mod) and requested or fallback
end

local HAS_MOD = function(mod) 
    return next(SMODS.find_mod(mod)) ~= nil
end

UF = {
    DESCRIPTIONS = {
    },

    RARITY = {
        GET = GET_RAR,
    },

    MODS = {
        CRYPTID = HAS_MOD("Cryptid"),
        POLTERWORX = HAS_MOD("jen"),
    },

    INCREASE_WEIGHT = 10,
    USED_INCREASE_WEIGHT = 10,

    U = {},
}

local function load_desc(name, tooltip_key, desc_key)
    G.localization.descriptions.Other[tooltip_key] = {
        name = name,
        text = UF.DESCRIPTIONS[desc_key]
    }
end

GIVE_JOKER = function(joker) 
    local c = create_card("Joker", G.jokers, nil, nil, nil, nil, joker);
    c:add_to_deck();
    G.jokers:emplace(c);
end

local set_edition_ref = Card.set_edition
function Card:set_edition(edition, immediate, silent)
    if edition == nil then return nil end
    for i=1, #edition do
        if not G.P_CENTERS[edition[i]] then
            return nil
        end
    end
    return set_edition_ref(self, edition, immediate, silent)
end