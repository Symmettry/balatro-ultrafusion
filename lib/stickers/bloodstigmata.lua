SMODS.Sticker {
    key = "blood_stigmata",

    -- atlas = "stickers",
    -- pos = { x = 0, y = 0 },

    config = {
        devotion = 1
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.ultrafusion_blood_stigmata.devotion
            }
        }
    end,

    badge_colour = HEX("8b0000"),
    sets = {
        Card = true
    },
    rate = 0,

    should_apply = function(self, card, center, area, bypass_roll)
        return false
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            local devotion = card.ability.ultrafusion_blood_stigmata.devotion
            local amount = 2 ^ devotion
            local upgrade = pseudorandom(pseudoseed("blood_stigmata_perma"))
            if upgrade < 0.2 then
                UF.U.add_perma_bonus(card, amount)
            elseif upgrade < 0.4 then
                UF.U.add_perma_mult(card, amount)
            elseif upgrade < 0.6 then
                UF.U.add_perma_xmult(card, amount)
            elseif upgrade < 0.8 then
                UF.U.add_perma_xchips(card, amount)
            else
                UF.U.add_perma_dollars(card, amount)
            end

            local aurora = card.ability.ultrafusion_blood_stigmata.aurora_data
            print(aurora.blood, aurora.min_blood + devotion)
            if aurora.blood > aurora.min_blood + devotion then
                aurora.blood = aurora.blood - devotion
                card.ability.ultrafusion_blood_stigmata.devotion = devotion + 1
            end

            return {
                message = localize('k_upgrade_ex')
            }
        end
    end,
}