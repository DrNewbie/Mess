_G.Rage_Special = _G.Rage_Special or {}

local PlayerStandard_update_check_actions_Deadeye = PlayerStandard._update_check_actions

function PlayerStandard:_update_check_actions(...)
	if Rage_Special.Block_SomeThing then
		self:_update_ground_ray()
		self:_update_fwd_ray()
		self:_update_movement(...)
		return
	end
	return PlayerStandard_update_check_actions_Deadeye(self, ...)
end

local PlayerStandard_get_max_walk_speed_Deadeye = PlayerStandard._get_max_walk_speed

function PlayerStandard:_get_max_walk_speed(...)
	local _ans = PlayerStandard_get_max_walk_speed_Deadeye(self, ...)
	return Rage_Special.Block_SomeThing and _ans*0.05 or _ans
end