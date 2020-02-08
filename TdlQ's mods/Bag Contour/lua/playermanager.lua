local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local bc_original_playermanager_serverdropcarry = PlayerManager.server_drop_carry
function PlayerManager:server_drop_carry(carry_id, ...)
	local unit = bc_original_playermanager_serverdropcarry(self, carry_id, ...)
	if unit then
		unit:interaction():set_contour(carry_id, 1)
	end
	return unit
end

local bc_original_playermanager_synccarrydata = PlayerManager.sync_carry_data
function PlayerManager:sync_carry_data(unit, carry_id, ...)
	bc_original_playermanager_synccarrydata(self, unit, carry_id, ...)
	unit:interaction():set_contour(carry_id, 1)
end
