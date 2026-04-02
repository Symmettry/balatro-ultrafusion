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

    U = {},
}

local function load_desc(name, tooltip_key, desc_key)
    G.localization.descriptions.Other[tooltip_key] = {
        name = name,
        text = UF.DESCRIPTIONS[desc_key]
    }
end

SMODS.current_mod.process_loc_text = function()
end

GIVE_JOKER = function(joker) 
    local c = create_card("Joker", G.jokers, nil, nil, nil, nil, joker);
    c:add_to_deck();
    G.jokers:emplace(c);
end