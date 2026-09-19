local ThisModPath = ModPath
local ThisModPathIds = Idstring(ThisModPath):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModPathIds):key()

PoisonBulletBase[Hook2] = PoisonBulletBase[Hook2] or PoisonBulletBase.start_dot_damage

function PoisonBulletBase:start_dot_damage(col_ray, weapon_unit, ...)
	if type(col_ray) == "table" and col_ray.unit and col_ray.hit_position and alive(col_ray.unit) and weapon_unit and alive(weapon_unit) and weapon_unit:base() and type(weapon_unit:base()._ammo_data.dot_data) == "table" then
		local wep_dot_data = weapon_unit:base()._ammo_data.dot_data
		if type(wep_dot_data.custom_data) == "table" and wep_dot_data.custom_data.dot_trigger_max_distance then
			local dot_trigger_max_distance = tonumber(wep_dot_data.custom_data.dot_trigger_max_distance)
			local dot_distance = mvector3.distance(col_ray.hit_position, weapon_unit:position())
			if dot_distance > dot_trigger_max_distance then
				return
			end
		end
	end
	return self[Hook2](self, col_ray, weapon_unit, ...)
end