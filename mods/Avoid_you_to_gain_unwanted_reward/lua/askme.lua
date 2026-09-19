_G.EXPRewardLater = _G.EXPRewardLater or {}

local EXPRewardLater_AskMe_Now = false

function EXPRewardLater:_Turn_On_Avoid()
	self.settings.SaveThisTime = 1
	self:Save()
	self:Announce()
end

function EXPRewardLater:_Turn_Off_Avoid()
	self.settings.SaveThisTime = 0
	self:Save()
	self:Announce()
end

Hooks:Add("GameSetupUpdate", "EXPRewardLater_AskMe", function(t, dt)
	if not Utils:IsInHeist() or EXPRewardLater_AskMe_Now then
		return
	end
	EXPRewardLater_AskMe_Now = true
	managers.system_menu:show({
		title = "Reward Later",
		text = "Do you want to avoid this time reward?",
		button_list = {
			{ text = "[Yes]", callback_func = callback(EXPRewardLater, EXPRewardLater, "_Turn_On_Avoid", {})},
			{ text = "[No]", callback_func = callback(EXPRewardLater, EXPRewardLater, "_Turn_Off_Avoid", {})},
			{ text = "OK", is_cancel_button = true }
		},
		id = tostring(math.random(0,0xFFFFFFFF))
	})
end)