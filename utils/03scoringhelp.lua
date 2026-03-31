-- =========================================================
-- scoring name helpers
-- =========================================================

function UF.U.scoring_name(context, name)
    return context and context.scoring_name == name
end

function UF.U.is_high_card(context) return UF.U.scoring_name(context, "High Card") end
function UF.U.is_pair(context) return UF.U.scoring_name(context, "Pair") end
function UF.U.is_two_pair(context) return UF.U.scoring_name(context, "Two Pair") end
function UF.U.is_three_kind(context) return UF.U.scoring_name(context, "Three of a Kind") end
function UF.U.is_straight(context) return UF.U.scoring_name(context, "Straight") end
function UF.U.is_flush(context) return UF.U.scoring_name(context, "Flush") end
function UF.U.is_full_house(context) return UF.U.scoring_name(context, "Full House") end
function UF.U.is_four_kind(context) return UF.U.scoring_name(context, "Four of a Kind") end
function UF.U.is_straight_flush(context) return UF.U.scoring_name(context, "Straight Flush") end

function UF.U.merge_joker_effects(a, b)
	if not a then return b end
	if not b then return a end

	local out = {}

	for k, v in pairs(a) do
		out[k] = v
	end

	local product_keys = { emult = true, e_mult = true, echips = true, e_chips = true, xmult = true, x_mult = true, xchips = true, x_chips = true }

	for k, v in pairs(b) do
		if type(v) == "number" and type(out[k]) == "number" then
			if product_keys[k] then
				out[k] = out[k] * v
			else
				out[k] = out[k] + v
			end
		elseif type(v) == "string" and type(out[k]) == "string" then
			out[k] = out[k] .. " & " .. v
		else
			out[k] = v
		end
	end

	return out
end

function UF.U.GAME_OVER() 
    G.E_MANAGER:add_event(Event({
        func = function()
            G.STATE = G.STATES.GAME_OVER
            G.STATE_COMPLETE = false
            return true
        end
    }))
end