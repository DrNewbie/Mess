_G.Rage_Special = _G.Rage_Special or {}
if not Utils:IsInHeist() then
	return
end
if not managers.player:has_category_upgrade("temporary", "berserker_damage_multiplier") then
	return
end
if Rage_Special.Rage_Point == Rage_Special.Rage_Point_Max and not Rage_Special.Activating then
	Rage_Special.Activating = true
	managers.player:player_unit():character_damage():forced_swansong()
end