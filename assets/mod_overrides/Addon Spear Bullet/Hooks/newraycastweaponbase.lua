function NewRaycastWeaponBase:__clbk_wpn_fps_sss_spear_unit_loaded()
	self.__is_wpn_fps_sss_spear = true
	self.__wpn_fps_sss_spear_bomb = {}
	self.__wpn_fps_sss_spear_hit_slot = managers.slot:get_mask("arrow_impact_targets")
	self.__wpn_fps_sss_spear_dt = 0
end

Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", "F_"..Idstring("PostHook:NewRaycastWeaponBase:_update_stats_values:Addition Spear Bullet"):key(), function(self)
	if not self.__is_wpn_fps_sss_spear_init and alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_sss_spear") then
		self.__is_wpn_fps_sss_spear_init = true
		self.__wpn_fps_sss_spear_unit_name = Idstring("units/pd2_dlc_steel/weapons/wpn_prj_jav/wpn_prj_jav_husk")
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), self.__wpn_fps_sss_spear_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), self.__wpn_fps_sss_spear_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "__clbk_wpn_fps_sss_spear_unit_loaded"))
		else
			self:__clbk_wpn_fps_sss_spear_unit_loaded()
		end
	end
end)

Hooks:PostHook(NewRaycastWeaponBase, "_fire_raycast", "F_"..Idstring("PostHook:NewRaycastWeaponBase:_fire_raycast:Addition Spear Bullet"):key(), function(self, __user_unit, __from_pos, __direction)
	if Utils and self.__is_wpn_fps_sss_spear then
		local __camera = managers.player:player_unit():movement()._current_state._ext_camera
		local __camera_pos = __camera:forward()
		local __now = TimerManager:game():time()
		if __now > self.__wpn_fps_sss_spear_dt then
			self.__wpn_fps_sss_spear_dt = __now + 3
			local __now_ids = Idstring(tostring(__now).."_"..self.__wpn_fps_sss_spear_unit_name:key()):key()
			if not self.__wpn_fps_sss_spear_bomb["M_"..__now_ids] then
				local __mvec_to = Vector3()
				local __unit = safe_spawn_unit(self.__wpn_fps_sss_spear_unit_name, __from_pos, Rotation())
				if __unit then
					__unit:set_rotation(Rotation(0, 0, 0))
					mvector3.set(__mvec_to, __camera_pos)
					mvector3.multiply(__mvec_to, 100)
					mvector3.add(__mvec_to, __unit:position())
					self.__wpn_fps_sss_spear_bomb["M_"..__now_ids] = {
						__dead_t = TimerManager:game():time() + 5,
						__to_pos = __mvec_to,
						__from_pos = __unit:position(),
						__unit = __unit
					}
				end
			end
		end
	end
end)
