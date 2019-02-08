_G.RWSN2W = _G.RWSN2W or {}

RWSN2W:Add("LowDmgWepatDS", function(weapon_data, stat_name, stat_data, them)
	if Utils and Utils:IsInGameState() and Global.game_settings and Global.game_settings.difficulty and Global.game_settings.difficulty == "sm_wish" then
		if stat_name == "damage" then
			local damage_e = tonumber(stat_data.equip)
			if damage_e then
				if damage_e <= 40 then
					RWSN2W:Simple_Set(them, "damage", "git gud (from your friendly DS)", Color(0, 1, 0))
				end
			end
		end
	end
end)