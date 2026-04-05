-- =========================================================
-- manual override state
-- =========================================================

UF.STATE = UF.STATE or {}
UF.STATE.manual_effects = UF.STATE.manual_effects or {}

function UF.U.set_manual_effect(key, val)
    UF.STATE.manual_effects[key] = not not val
end

function UF.U.get_manual_effect(key)
    return not not UF.STATE.manual_effects[key]
end