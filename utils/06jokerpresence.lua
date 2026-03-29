-- =========================================================
-- joker presence helpers
-- =========================================================

function UF.U.jokers()
    return (G and G.jokers and G.jokers.cards) or {}
end

function UF.U.has_joker(center_key)
    for _, joker in ipairs(UF.U.jokers()) do
        if joker and joker.config and joker.config.center_key == center_key then
            return true, joker
        end
    end
    return false, nil
end

function UF.U.count_joker(center_key)
    local n = 0
    for _, joker in ipairs(UF.U.jokers()) do
        if joker and joker.config and joker.config.center_key == center_key then
            n = n + 1
        end
    end
    return n
end
