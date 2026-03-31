UF.U.BLOOD = UF.U.BLOOD or {}

function UF.U.BLOOD.clamp_blood(card)
    if card.ability.extra.blood < card.ability.extra.min_blood then
        card.ability.extra.blood = card.ability.extra.min_blood
    end
    if card.ability.extra.blood > card.ability.extra.max_blood then
        card.ability.extra.blood = card.ability.extra.max_blood
    end
end

function UF.U.BLOOD.get_rarity_blood_delta(rarity)
    -- im not sure what the names are. oof
    if rarity == 1 or rarity == "Common" or rarity == "common" then
        return -0.1
    end

    if rarity == 2
        or rarity == "Uncommon"
        or rarity == "uncommon"
        or rarity == "fusion" then
        return 0.1
    end

    if rarity == 3
        or rarity == "Rare"
        or rarity == "rare"
        or rarity == "advfusion"
        or rarity == "ultrafusion_advfusion" then
        return 1
    end

    if rarity == 4
        or rarity == "Legendary"
        or rarity == "legendary"
        or rarity == "heroicfusion"
        or rarity == "ultrafusion_heroicfusion"
        or rarity == "legfusion"
        or rarity == "ultrafusion_legfusion" then
        return 10
    end

    return 0
end

function UF.U.BLOOD.is_face_card(playing_card)
    return playing_card
        and playing_card:is_face()
end

function UF.U.BLOOD.is_lucky_or_glass(playing_card)
    return playing_card
        and playing_card.ability
        and (
            playing_card.ability.name == "Lucky Card"
            or playing_card.ability.name == "Glass Card"
        )
end

function UF.U.BLOOD.aurora()
    return SMODS.find_card("j_ultrafusion_aurora_the_prophesied_cataclysm")
end

local calculate_ref = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if (key == "chips" or key == "mult" or key == "chips_mod" or key == "mult_mod" or key == "xchips" or key == "xmult" or key == "xchips_mod" or key == "xmult_mod") then
        local aurora = UF.U.BLOOD.aurora()
        if aurora ~= nil and aurora[1] ~= nil then
            local multiplier = aurora[1].ability.extra.blood * aurora[1].sell_cost
            amount = amount * multiplier
        end
    end
    return calculate_ref(effect, scored_card, key, amount, from_edition)
end