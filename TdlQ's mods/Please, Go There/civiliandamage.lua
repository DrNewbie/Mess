local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civiliandamage_liedownclbk = CivilianDamage._lie_down_clbk
function CivilianDamage:_lie_down_clbk(...)
	local brain = alive(self._unit) and self._unit:brain()
	if brain then
		if brain:is_hostage() then
			brain:on_hostage_move_interaction(nil, 'stay')
			self._lie_down_clbk_id = nil
		else
			pgt_original_civiliandamage_liedownclbk(self, ...)
		end
	end
end
