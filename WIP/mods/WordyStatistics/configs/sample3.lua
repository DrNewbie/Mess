_G.RWSN2W = _G.RWSN2W or {}

RWSN2W:Add(nil, function(weapon_data, stat_name, stat_data, them)
	RWSN2W:Simple_Set_Weapon_Title(them, nil, Color(math.random(), math.random(), math.random()))
end)