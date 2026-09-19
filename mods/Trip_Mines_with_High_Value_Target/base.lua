local ThisModPath = ModPath

local __Name = function(__id)
	return "YYY_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")

local function this_high_value_target(this_owner, this_sensor_units_detected)
	local ply = managers.player:player_unit()
	if ply and managers.player:has_category_upgrade("player", "marked_inc_dmg_distance") and type(this_owner) == type(ply) and this_owner == ply and type(this_sensor_units_detected) == "table" then
		local enemies_list = managers.enemy:all_enemies()
		for u_key, u_yes in pairs(this_sensor_units_detected) do
			if enemies_list[u_key] and enemies_list[u_key].unit and alive(enemies_list[u_key].unit) then
				local __u = enemies_list[u_key].unit
				if __u.contour and __u:contour() and type(__u:contour().add) == "function" then
					__u:contour():add("mark_enemy_damage_bonus_distance", false, managers.player:upgrade_value("player", "mark_enemy_time_multiplier", 1))
				end
			end
		end
	end
	return
end

Hooks:PostHook(TripMineBase, "_sensor", __Name(1), function(self, ...)
	if self[is_bool] then
		self[is_bool] = false
		pcall(this_high_value_target, self._owner, self._sensor_units_detected)
	end
end)

Hooks:PostHook(TripMineBase, "_emit_sensor_sound_and_effect", __Name(2), function(self, ...)
	self[is_bool] = true
end)