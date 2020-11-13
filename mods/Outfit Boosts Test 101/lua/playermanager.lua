local old_get_skill_exp_multiplier = PlayerManager.get_skill_exp_multiplier

function PlayerManager:get_skill_exp_multiplier(...)
	local ans1 = old_get_skill_exp_multiplier(self, ...)
	local las = tostring(managers.blackmarket:equipped_player_style())
	if type(ans1) == "number" and Global.level_data and Global.level_data.level_id and Global.level_data.level_id == "dinner" and las == "slaughterhouse" then
		ans1 = math.max(ans1, 1) * 10
	end
	return ans1
end