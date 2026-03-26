local GET_RAR = function (requested, fallback, mod)
    return next(SMODS.find_mod(mod)) and requested or fallback
end

FUSION = {
    DESCRIPTIONS = {
    },

    RARITY = {
        GET = GET_RAR,
    }
}

local function load_desc(name, tooltip_key, desc_key)
    G.localization.descriptions.Other[tooltip_key] = {
        name = name,
        text = FUSION.DESCRIPTIONS[desc_key]
    }
end

SMODS.current_mod.process_loc_text = function()
end

GIVE_JOKER = function(joker) 
    local c = create_card("Joker", G.jokers, nil, nil, nil, nil, joker);
    c:add_to_deck();
    G.jokers:emplace(c);
end