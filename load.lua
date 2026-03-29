local mod = SMODS.current_mod

LOAD("globals.lua")
LOAD("rarity.lua")

local config = assert(SMODS.load_file("config.lua"))()

local function load_mod_files(folder)
    local base_path = mod.path .. folder
    local items = NFS.getDirectoryItems(base_path)

    for _, item in ipairs(items) do
        local full_path = base_path .. "/" .. item
        local relative_path = folder .. "/" .. item
        local info = NFS.getInfo(full_path)

        if info and info.type == "directory" then
            load_mod_files(relative_path)
        elseif info and info.type == "file" and item:match("%.lua$") then
            LOAD(relative_path)
        end
    end
end

load_mod_files("utils")
load_mod_files("lib")


-- Generate tree

local function escape_dot(str)
    str = tostring(str)
    str = str:gsub("\\", "\\\\")
    str = str:gsub('"', '\\"')
    return str
end

local function q(str)
    return '"' .. escape_dot(str) .. '"'
end

local function normalize_joker_ref(v)
    if type(v) == "string" then
        return v
    end

    if type(v) ~= "table" then
        return tostring(v)
    end

    -- Your fusion ingredient objects use .name
    if type(v.name) == "string" then
        return v.name
    end

    -- Fallbacks just in case
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

local function collect_recipes(fusions)
    local recipes = {}

    for _, v in pairs(fusions) do
        if is_recipe_entry(v) then
            local recipe = {
                result_joker = v.result_joker,
                jokers = {},
                cost = v.cost
            }

            for i, ing in ipairs(v.jokers) do
                recipe.jokers[i] = normalize_joker_ref(ing)
            end

            recipes[#recipes + 1] = recipe
        end
    end

    return recipes
end

local function build_result_map(recipes)
    local produced = {}
    for _, recipe in ipairs(recipes) do
        produced[recipe.result_joker] = recipe
    end
    return produced
end

local function collect_base_jokers(recipes, produced)
    local base = {}
    for _, recipe in ipairs(recipes) do
        for _, ing in ipairs(recipe.jokers) do
            if not produced[ing] then
                base[ing] = true
            end
        end
    end
    return base
end

local function compute_tier(node, produced, memo, visiting)
    if memo[node] then
        return memo[node]
    end

    if visiting[node] then
        error("Cycle detected involving " .. tostring(node))
    end

    local recipe = produced[node]
    if not recipe then
        memo[node] = 1
        return 1
    end

    visiting[node] = true

    local max_parent_tier = 1
    for _, ing in ipairs(recipe.jokers) do
        local parent_tier = compute_tier(ing, produced, memo, visiting)
        if parent_tier > max_parent_tier then
            max_parent_tier = parent_tier
        end
    end

    visiting[node] = nil
    memo[node] = max_parent_tier + 1
    return memo[node]
end

local function sorted_array(arr)
    table.sort(arr, function(a, b) return tostring(a) < tostring(b) end)
    return arr
end

local function tier_label(tier)
    if tier == 1 then return "Base Jokers" end
    if tier == 2 then return "Basic Fusions" end
    if tier == 3 then return "Advanced Fusions" end
    if tier == 4 then return "Heroic Fusions" end
    if tier == 5 then return "Legendary Fusions" end
    if tier == 6 then return "Ultimate Fusions" end
    return "Tier " .. tostring(tier)
end

local function tier_colors(tier)
    if tier == 1 then
        -- base tier below basic should still be gray
        return "#888888", "#f0f0f0"
    elseif tier == 2 then
        -- Basic
        return "#f7d762", "#feffb5"
    elseif tier == 3 then
        -- Advanced Fusion
        return "#36b43b", "#e3f7e4"
    elseif tier == 4 then
        -- Heroic Fusion
        return "#0e6780", "#d9eef4"
    elseif tier == 5 then
        -- Legendary Fusion
        return "#8409c2", "#eedcff"
    elseif tier == 6 then
        -- Ultimate Fusion
        return "#5f0000", "#f4d9d9"
    else
        return "#dddddd", "#f3f3f3"
    end
end

local function generate_dot(fusions)
    local recipes = collect_recipes(fusions)
    local produced = build_result_map(recipes)
    local base_set = collect_base_jokers(recipes, produced)

    local memo = {}
    local tiers = {}
    local max_tier = 1

    for base_name, _ in pairs(base_set) do
        memo[base_name] = 1
    end

    for result_name, _ in pairs(produced) do
        local t = compute_tier(result_name, produced, memo, {})
        tiers[result_name] = t
        if t > max_tier then
            max_tier = t
        end
    end

    local nodes_by_tier = {}
    for i = 1, max_tier do
        nodes_by_tier[i] = {}
    end

    for base_name, _ in pairs(base_set) do
        nodes_by_tier[1][#nodes_by_tier[1] + 1] = base_name
    end

    for result_name, t in pairs(tiers) do
        nodes_by_tier[t][#nodes_by_tier[t] + 1] = result_name
    end

    for i = 1, max_tier do
        sorted_array(nodes_by_tier[i])
    end

    local lines = {}

    lines[#lines + 1] = "digraph FusionTree {"
    lines[#lines + 1] = '    graph [rankdir=TB, splines=true, nodesep=0.35, ranksep=0.8];'
    lines[#lines + 1] = '    node [shape=box, style="rounded,filled", fillcolor="#f8f8f8", color="#666666", fontname="Arial"];'
    lines[#lines + 1] = '    edge [color="#666666", arrowsize=0.7];'
    lines[#lines + 1] = ""

    for tier = 1, max_tier do
        local border, fill = tier_colors(tier)

        lines[#lines + 1] = "    subgraph cluster_tier_" .. tier .. " {"
        lines[#lines + 1] = "        label=" .. q(tier_label(tier)) .. ";"
        lines[#lines + 1] = "        color=" .. q(border) .. ";"
        lines[#lines + 1] = '        style="rounded";'
        lines[#lines + 1] = ""

        for _, node in ipairs(nodes_by_tier[tier]) do
            lines[#lines + 1] = "        " .. q(node) .. " [fillcolor=" .. q(fill) .. "];"
        end

        lines[#lines + 1] = "    }"
        lines[#lines + 1] = ""
    end

    lines[#lines + 1] = "    // Edges"
    local sorted_results = {}
    for result_name, _ in pairs(produced) do
        sorted_results[#sorted_results + 1] = result_name
    end
    table.sort(sorted_results, function(a, b) return tostring(a) < tostring(b) end)

    for _, result_name in ipairs(sorted_results) do
        local recipe = produced[result_name]
        for _, ing in ipairs(recipe.jokers) do
            lines[#lines + 1] = "    " .. q(ing) .. " -> " .. q(result_name) .. ";"
        end
    end
    lines[#lines + 1] = ""

    lines[#lines + 1] = "    // Rank alignment"
    for tier = 1, max_tier do
        lines[#lines + 1] = "    { rank=same;"
        for _, node in ipairs(nodes_by_tier[tier]) do
            lines[#lines + 1] = "        " .. q(node) .. ";"
        end
        lines[#lines + 1] = "    }"
        lines[#lines + 1] = ""
    end

    lines[#lines + 1] = "}"

    return table.concat(lines, "\n")
end

local function write_file(path, contents)
    local file, err = io.open(path, "w")
    if not file then
        error("Failed to open file: " .. tostring(err))
    end
    file:write(contents)
    file:close()
end

local output_path = "D:\\lily\\.local\\share\\love\\Mods\\Balatro-UltraFusion\\fusion_tree.dot"

if not FusionJokers or not FusionJokers.fusions then
    error("FusionJokers.fusions was not found")
end

local dot = generate_dot(FusionJokers.fusions)
write_file(output_path, dot)

print("Wrote Graphviz DOT to: " .. output_path)