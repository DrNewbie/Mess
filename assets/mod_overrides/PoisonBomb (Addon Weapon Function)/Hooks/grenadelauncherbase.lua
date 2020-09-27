local mod_ids = Idstring("PoisonBomb (Addon Weapon Function)"):key()
local func01 = "F_"..Idstring("func01:"..mod_ids):key()

Hooks:PostHook(GrenadeLauncherBase, "_update_stats_values", "F_"..Idstring("PostHook:GrenadeLauncherBase:_update_stats_values:Husk Tripmine:PoisonBomb"):key(), function(self)
	if not DB:has(Idstring("unit"), Idstring("units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine_husk")) then
	
	else
		if not self.__is_wpn_fps_sss_poisonbomb_init and alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_sss_poisonbomb") then
			self.__is_wpn_fps_sss_poisonbomb_init = true
			self.__is_wpn_fps_sss_poisonbomb = true
		end
	end
end)

local __old_fire_raycast = GrenadeLauncherBase._fire_raycast

function ProjectileWeaponBase:_fire_raycast(user_unit, from_pos, direction, ...)
	if self.__is_wpn_fps_sss_poisonbomb then
		TripMineBase[func01](from_pos + direction * 10, direction, true)
		return {}
	end
	return __old_fire_raycast(self, user_unit, from_pos, direction, ...)
end