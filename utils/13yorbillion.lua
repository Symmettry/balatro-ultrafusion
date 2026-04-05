function UF.U.one_yorbillion()
    local visited = {}

    local function is_valid_number(v)
        return type(v) == "number"
            and v == v
            and v ~= math.huge
            and v ~= -math.huge
            and math.abs(v) < 1e200
    end

    local function should_count_number(v)
        if not is_valid_number(v) then
            return false
        end

        local abs_v = math.abs(v)
        return (abs_v % 1 ~= 0) or (abs_v % 10 ~= 0)
    end

    local function collect_numbers(tbl, out)
        if type(tbl) ~= "table" or visited[tbl] then
            return
        end
        visited[tbl] = true

        for _, v in pairs(tbl) do
            if should_count_number(v) then
                out[#out + 1] = v
            elseif type(v) == "table" then
                collect_numbers(v, out)
            end
        end
    end

    local values = {}
    collect_numbers(G, values)

    local result = Big:create(0)

    for _, v in ipairs(values) do
        local safe_val = math.abs(v)

        if should_count_number(safe_val) then
            local val = Big:create(safe_val)
            if val then
                local r = result:add(val)
                if r then
                    result = r
                end
            end
        end
    end

    return result
end
