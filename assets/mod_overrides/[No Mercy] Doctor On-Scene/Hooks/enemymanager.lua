if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" then
	return
end

local New_get_nearby_medic = EnemyManager.get_nearby_medic

function EnemyManager:get_nearby_medic(unit)
	if self:is_civilian(unit) then
		return nil
	end
	local Ans = New_get_nearby_medic(self, unit)
	if not Ans then
		if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" then
			return nil
		end
		local enemies = World:find_units_quick(unit, "sphere", unit:position(), tweak_data.medic.radius * 2, managers.slot:get_mask("enemies"))
		for _, enemy in ipairs(enemies) do
			if enemy:base()._medic_now then
				return enemy
			end
		end	
	end
	return Ans
end