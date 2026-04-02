local function normalize_joker_ref(v)
    if type(v) == "string" then
        return v
    end

    if type(v) ~= "table" then
        return tostring(v)
    end

    if type(v.name) == "string" then
        return v.name
    end

    if type(v.key) == "string" then
        return v.key
    end

    if v.config and type(v.config.center_key) == "string" then
        return v.config.center_key
    end

    if v.center and type(v.center.key) == "string" then
        return v.center.key
    end

    return tostring(v)
end

local function is_recipe_entry(v)
    return type(v) == "table"
       and type(v.jokers) == "table"
       and type(v.result_joker) == "string"
end

local function build_basic_joker_partner_table(fusions)
    local recipes = {}
    local produced = {}

    -- collect recipes and produced jokers
    for _, v in pairs(fusions) do
        if is_recipe_entry(v) then
            local recipe = {
                result_joker = v.result_joker,
                jokers = {}
            }

            for i, ing in ipairs(v.jokers) do
                recipe.jokers[i] = normalize_joker_ref(ing)
            end

            recipes[#recipes + 1] = recipe
            produced[recipe.result_joker] = true
        end
    end

    -- find base/basic jokers
    local basic = {}
    for _, recipe in ipairs(recipes) do
        for _, ing in ipairs(recipe.jokers) do
            if not produced[ing] then
                basic[ing] = true
            end
        end
    end

    -- build output table:
    -- ["j_joker1"] = { "j_joker2", "j_joker3" }
    local out = {}
    local seen = {}

    for basic_key, _ in pairs(basic) do
        out[basic_key] = {}
        seen[basic_key] = {}
    end

    for _, recipe in ipairs(recipes) do
        for i, ing in ipairs(recipe.jokers) do
            if basic[ing] then
                for j, other in ipairs(recipe.jokers) do
                    if i ~= j and other ~= ing and not seen[ing][other] then
                        seen[ing][other] = true
                        out[ing][#out[ing] + 1] = other
                    end
                end
            end
        end
    end

    -- sort each list
    for _, partners in pairs(out) do
        table.sort(partners, function(a, b)
            return tostring(a) < tostring(b)
        end)
    end

    return out
end

local fusion_partner_table = build_basic_joker_partner_table(FusionJokers.fusions)

local calc_ref = SMODS.calculate_context

function SMODS.calculate_context(context, return_table)
    if context and context.modify_weights and context.pool then
        for i = 1, #context.pool do
            local entry = context.pool[i]

            local fusions = fusion_partner_table[entry.key]
            if fusions ~= nil then
                for i = 1, #fusions do
                    local other = fusions[i]
                    if next(SMODS.find_card(other)) then
                        entry.weight = UF.USED_INCREASE_WEIGHT
                    end
                end
            end
        end
    end

    return calc_ref(context, return_table)
end