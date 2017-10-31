if Network:is_client() then
	return
end

_G.ShadowRaidLoud = _G.ShadowRaidLoud or {}

local _f_GroupAIStateBase_update_point_of_no_return = GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(...)
	if ShadowRaidLoud and ShadowRaidLoud.Enable and ShadowRaidLoud.Timer_Enable then
		managers.hud:hide_point_of_no_return_timer()
		managers.hud:remove_updator("point_of_no_return")
		self._point_of_no_return_timer = 0
		return
	end
	_f_GroupAIStateBase_update_point_of_no_return(self, ...)
end