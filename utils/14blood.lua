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
    if rarity == 1 or rarity == "Common" or rarity == "common" or rarity == "crp_trash" then
        return -0.1
    end

    if     rarity == 2
        or rarity == "Uncommon"
        or rarity == "uncommon"
        or rarity == "fusion" then
        return 1
    end

    if     rarity == 3
        or rarity == "Rare"
        or rarity == "rare"
        or rarity == "ultrafusion_advfusion" then
        return 5
    end

    if     rarity == "cry_epic"
        or rarity == "ultrafusion_heroicfusion" then
        return 15
    end

    if     rarity == 4
        or rarity == "Legendary"
        or rarity == "legendary" then
        return 20
    end

    if     rarity == "ultrafusion_legfusion"
        or rarity == "cry_exotic" then
        return 40
    end

    if     rarity == "ultrafusion_ultfusion" then
        return 100
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
    -- bruh
    if (key == "chips" or key == "mult" or key == "chips_mod" or key == "mult_mod" or key == "xchips" or key == "xmult" or key == "xchips_mod" or key == "xmult_mod" or key == "x_chips" or key == "x_mult" or key == "Xmult_mod" or key == "Xchips_mod" or key == "Xmult" or key == "Xchips") then
        local aurora = UF.U.BLOOD.aurora()
        if aurora ~= nil and aurora[1] ~= nil then
            local multiplier = aurora[1].ability.extra.blood * aurora[1].sell_cost
            amount = amount * multiplier
        end
    end
    return calculate_ref(effect, scored_card, key, amount, from_edition)
end

function UF.U.BLOOD.has_blood_stigmata(card)
    return card
        and card.ability
        and card.ability.ultrafusion_blood_stigmata ~= nil
end

function UF.U.BLOOD.strip_blood_stigmata_copy(card)
    if not card then return end

    -- remove Blood Stigmata itself
    if card.ability then
        card.ability.ultrafusion_blood_stigmata = nil
    end

    if card.ability and card.ability.stickers then
        card.ability.stickers.blood_stigmata = nil
    end

    if card.stickers then
        card.stickers.blood_stigmata = nil
    end

    -- wipe permanent bonuses
    if card.ability then
        card.ability.perma_bonus = 0
        card.ability.perma_mult = 0
        card.ability.perma_xmult = 0
        card.ability.perma_xchips = 0
        card.ability.perma_p_dollars = 0
        card.ability.perma_h_dollars = 0
        card.ability.perma_h_mult = 0
        card.ability.perma_h_chips = 0
    end

    -- remove edition
    if card.edition then
        card.edition = nil
    end
    if card.set_edition then
        card:set_edition(nil, true, true)
    end

    -- remove seal
    if card.seal then
        card.seal = nil
    end
    if card.set_seal then
        card:set_seal(nil, true, true)
    end

    -- remove enhancement
    if card.config and card.config.center and card.config.center.set == "Enhanced" then
        if card.set_ability then
            card:set_ability(G.P_CENTERS.c_base, nil, true)
        else
            card.config.center = G.P_CENTERS.c_base
            card.ability = card.ability or {}
            card.ability.effect = nil
        end
    end

    -- clear common copied gameplay state
    if card.ability then
        card.ability.extra = {}
        card.ability.x_mult = 0
        card.ability.xmult = 0
        card.ability.mult = 0
        card.ability.h_mult = 0
        card.ability.chips = 0
        card.ability.h_chips = 0
        card.ability.p_dollars = 0
        card.ability.t_mult = 0
        card.ability.t_chips = 0
    end

    -- if it's a playing card, normalize rank/suit enhancements only, not the card identity itself
    if card.base then
        card.base.perma_bonus = 0
        card.base.perma_mult = 0
    end

    -- force UI/state refresh if available
    if card.set_cost then
        card:set_cost()
    end
end