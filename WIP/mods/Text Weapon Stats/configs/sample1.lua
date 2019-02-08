_G.RWSN2W = _G.RWSN2W or {}

RWSN2W:Add("Sample", function(weapon_data, stat_name, stat_data, them)
	if stat_name == "damage" then
		local damage_e = tonumber(stat_data.equip)
		if damage_e then
			if damage_e > 9000 then
				RWSN2W:Simple_Set(them, "damage", "IT'S OVER 9000!!!!!", Color(1, 0, 0))
			elseif damage_e > 4000 then
				RWSN2W:Simple_Set(them, "damage", "IT'S CLOSE TO 9000!!", Color(1, 1, 0))
			elseif damage_e <= 40 then
				RWSN2W:Simple_Set(them, "damage", "I'd rather kill myself", Color(0, 1, 1))
			end
		end
	end
end)