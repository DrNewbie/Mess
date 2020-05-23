local __ids_key = Idstring("keybind_RemoteStickybomb_BoomIt_keybind_id"):key()
_G[__ids_key] = _G[__ids_key] or {}

Hooks:PostHook(GrenadeLauncherBase, "_update_stats_values", "F_"..Idstring("PostHook:GrenadeLauncherBase:_update_stats_values:Husk Tripmine"):key(), function(self)
	if not DB:has(Idstring("unit"), Idstring("units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine_husk")) then
	
	else
		if not self.__is_wpn_fps_sss_stickybomb_init and alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_sss_stickybomb") then
			self.__is_wpn_fps_sss_stickybomb_init = true
			self.__is_wpn_fps_sss_stickybomb = true
		end
	end
end)

local __old_fire_raycast = GrenadeLauncherBase._fire_raycast

function ProjectileWeaponBase:_fire_raycast(user_unit, from_pos, direction, ...)
	if self.__is_wpn_fps_sss_stickybomb then
		local __bomb = TripMineBase.spawn_husk_fake_one(from_pos + direction * 10, direction, true)
		self.__stickbomb_unit = self.__stickbomb_unit or {}
		_G[__ids_key][Idstring(tostring(self)):key()] = self
		local __max = 4
		local __is_full
		for i = 1, __max do
			if self.__stickbomb_unit[i] and alive(self.__stickbomb_unit[i]) then
			
			else
				__is_full = i
				break
			end
		end
		if __is_full then
			self.__stickbomb_unit[__is_full] = __bomb
		else
			self.__stickbomb_unit[1]:base():explode()
			for i = 1, __max - 1 do
				self.__stickbomb_unit[i] = self.__stickbomb_unit[i+1]
			end
			self.__stickbomb_unit[__max] = __bomb
		end
		return {}
	end
	return __old_fire_raycast(self, user_unit, from_pos, direction, ...)
end