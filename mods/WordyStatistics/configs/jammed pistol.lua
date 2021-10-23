_G.RWSN2W = _G.RWSN2W or {}

RWSN2W:Add(nil, function(weapon_data, stat_name, stat_data, them)
	if stat_name == "fire_rate" then
		local fire_rate_e = tonumber(stat_data.equip)
		local weapon_id = weapon_data.weapon_id
		if fire_rate_e and fire_rate_e <= 300 and tweak_data.weapon[weapon_id] and table.contains(tweak_data.weapon[weapon_id].categories, "pistol") then
			RWSN2W:Simple_Set(them, "fire_rate", "The gun jams every time", TextGui.COLORS.orange)
		end
	end
end)