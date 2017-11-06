local Melee_Toggle_Hold = false
local Melee_Toggle_check_action_melee = PlayerStandard._check_action_melee
function PlayerStandard:_check_action_melee(t, input)
	if input.btn_melee_press then
		Melee_Toggle_Hold = not Melee_Toggle_Hold
	end	
	if Melee_Toggle_Hold then
		input.btn_melee_release = false
	end
	return Melee_Toggle_check_action_melee(self, t, input)
end