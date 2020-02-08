local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_teamaimovement_switchtonotcool = HuskTeamAIMovement._switch_to_not_cool
function HuskTeamAIMovement:_switch_to_not_cool(...)
	fs_original_teamaimovement_switchtonotcool(self, ...)
	self._unit:inventory():_ensure_weapon_visibility()
end
