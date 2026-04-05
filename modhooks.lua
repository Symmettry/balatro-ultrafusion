if UF.MODS.CRYPTID then
	local calc_ref = SMODS.calculate_context

	local function cry_misprint_deck_active()
		if not G or not G.GAME then return false end

		local back = G.GAME.selected_back or G.GAME.back
		local key = back and (
			(back.effect and back.effect.center and back.effect.center.key)
			or back.key
		)

		return key == "b_cry_misprint"
	end

	function SMODS.calculate_context(context, return_table)
		if context and context.fusing_jokers and context.fusion_result then
			local card = context.fusion_result

			if cry_misprint_deck_active()
				and card
				and card.ability
				and not card.ability.cry_fused_misprinted
			then
				card.ability.cry_fused_misprinted = true

				Cryptid.misprintize_tbl(
					card.config.center_key,
					card,
					"ability",
					false,
					nil,
					false,
					nil,
					nil,
					nil
				)
			end
		end

		return calc_ref(context, return_table)
	end
end