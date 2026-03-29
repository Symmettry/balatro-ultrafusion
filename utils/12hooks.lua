-- =========================================================
-- one-time hook installers
-- =========================================================

function UF.U.install_hooks()
    if UF._utils_hooks_installed then
        return
    end
    UF._utils_hooks_installed = true

    -- Four Fingers override
    UF.U._four_fingers_ref = UF.U._four_fingers_ref or SMODS.four_fingers
    SMODS.four_fingers = function(hand)
        if UF.U.back_alley_active() then
            return 4
        end
        if UF.U._four_fingers_ref then
            return UF.U._four_fingers_ref(hand)
        end
    end

    -- Shortcut override
    UF.U._shortcut_ref = UF.U._shortcut_ref or SMODS.shortcut
    SMODS.shortcut = function(...)
        if UF.U.back_alley_active() then
            return true
        end
        if UF.U._shortcut_ref then
            return UF.U._shortcut_ref(...)
        end
    end

    -- Pareidolia-style face card override
    UF.U._card_is_face_ref = UF.U._card_is_face_ref or Card.is_face
    function Card:is_face(from_boss)
        return UF.U._card_is_face_ref(self, from_boss) or UF.U.all_face_cards_active() or UF.U.all_kings_active()
    end

    -- Smeared Joker-style suit merging override
    UF.U._smeared_check_ref = UF.U._smeared_check_ref or SMODS.smeared_check
    SMODS.smeared_check = function(card, suit)
        if UF.U.all_suits_active() then
            return true
        end

        if UF.U.smeared_suits_active and UF.U.smeared_suits_active() and card and card.base and card.base.suit then
            local base_suit = card.base.suit

            if ((base_suit == 'Hearts' or base_suit == 'Diamonds') and
                (suit == 'Hearts' or suit == 'Diamonds')) then
                return true
            elseif ((base_suit == 'Spades' or base_suit == 'Clubs') and
                    (suit == 'Spades' or suit == 'Clubs')) then
                return true
            end
        end

        if UF.U._smeared_check_ref then
            return UF.U._smeared_check_ref(card, suit)
        end
        return false
    end

    local card_set_cost_ref = Card.set_cost
    function Card:set_cost()
        card_set_cost_ref(self)

        if UF.U.free_planets() then
            if self.ability and (
                self.ability.set == 'Planet' or
                (self.ability.set == 'Booster' and self.config.center.kind == 'Celestial')
            ) then
                self.cost = 0
            end

            self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
            self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
        end
    end
end

UF.U._card_get_id_ref = UF.U._card_get_id_ref or Card.get_id
function Card:get_id()
    local id = UF.U._card_get_id_ref(self)

    if UF.U.all_kings_active() and id then
        return 13
    end

    return id
end

UF.U.install_hooks()