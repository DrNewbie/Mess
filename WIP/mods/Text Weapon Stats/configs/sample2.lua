_G.RWSN2W = _G.RWSN2W or {}

RWSN2W:Add(nil, function(weapon_data, stat_name, stat_data, them)
	if stat_name == "spread" then
		local spread_e = tonumber(stat_data.equip)
		if spread_e then
			if spread_e < 40 then
				RWSN2W:Simple_Set(them, "spread", "Oops, so miss", Color(1, 0, 0))
			elseif spread_e == 100 then
				RWSN2W:Simple_Set(them, "spread", "1 0 0 %", Color(1, 0, 0))
			end
		end
	end
end)