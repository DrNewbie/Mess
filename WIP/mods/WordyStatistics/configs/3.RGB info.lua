_G.RWSN2W = _G.RWSN2W or {}

RWSN2W:Add(nil, function(weapon_data, stat_name, stat_data, them)
	RWSN2W:Simple_Set_Weapon_Title(them, nil, Color(math.random(), math.random(), math.random()))
	RWSN2W:Simple_Set(them, stat_name, nil, Color(math.random(), math.random(), math.random()))
	for _, other in pairs({"base", "mods", "skill"}) do
		them._stats_texts[stat_name][other]:set_color(Color(math.random(), math.random(), math.random()))
	end
end)