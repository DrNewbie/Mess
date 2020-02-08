local suis_original_playerstandard_insteelsight = PlayerStandard.in_steelsight
local function return_false()
	return false
end

local suis_original_playerstandard_checkactiondeployunderbarrel = PlayerStandard._check_action_deploy_underbarrel
function PlayerStandard:_check_action_deploy_underbarrel(...)
	self.in_steelsight = return_false
	local result = suis_original_playerstandard_checkactiondeployunderbarrel(self, ...)
	self.in_steelsight = suis_original_playerstandard_insteelsight
	return result
end
