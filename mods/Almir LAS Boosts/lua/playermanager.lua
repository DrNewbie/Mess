LegendaryArmours = LegendaryArmours or {}

F_135c7275b2456d85 = PlayerManager.get_skill_exp_multiplier

function PlayerManager:get_skill_exp_multiplier(...)
	local ans = F_135c7275b2456d85(self, ...)
	local las = tostring(managers.blackmarket:equipped_armor_skin())
	if LegendaryArmours[las] and (las == "almirsuit" or las == "almirhoodie") then
		ans = math.max(ans, 1) * 100
	end
	return ans
end