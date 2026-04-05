-- =========================================================
-- boss blind helpers
-- =========================================================

function UF.U.is_boss_blind(blind)
    blind = blind or UF.U.blind()
    return blind and blind.boss or false
end

function UF.U.to_disable_boss_blind(context)
    return UF.U.setting_blind(context) and UF.U.not_blueprint(context) and UF.U.is_boss_blind(context.blind)
end

function UF.U.blind_disabled(blind)
    blind = blind or UF.U.blind()
    if not blind then return false end
    return blind.disabled or false
end

function UF.U.can_disable_boss_blind(blind)
    blind = blind or UF.U.blind()
    return blind and UF.U.is_boss_blind(blind) and not UF.U.blind_disabled(blind)
end

function UF.U.disable_boss_blind(card, silent)
    local blind = UF.U.blind()
    if not UF.U.can_disable_boss_blind(blind) then
        return false
    end

    if blind.disable then
        blind:disable()
    else
        blind.disabled = true
    end

    if not silent then
        play_sound('timpani')
        SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
    end

    return true
end

function UF.U.disable_boss_blind_with_event(card)
    if not UF.U.can_disable_boss_blind() then
        return false
    end

    G.E_MANAGER:add_event(Event({
        func = function()
            G.E_MANAGER:add_event(Event({
                func = function()
                    UF.U.disable_boss_blind(card, true)
                    play_sound('timpani')
                    delay(0.4)
                    return true
                end
            }))
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            return true
        end
    }))

    return true
end

function UF.U.boss_blind_payout(base_dollars)
    return (base_dollars or 0) * UF.U.ante()
end