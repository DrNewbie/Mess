function ShotgunBase:__clbk_wpn_fps_sss_unmaykr_unit_loaded()
	self.__is_wpn_fps_sss_unmaykr = true
	self.__wpn_fps_sss_unmaykr_bomb = {}
	self.__wpn_fps_sss_unmaykr_hit_slot = managers.slot:get_mask("civilians", "enemies")
end

Hooks:PostHook(ShotgunBase, "setup_default", "F_"..Idstring("PostHook:ShotgunBase:setup_default:Super Weapon: Unmaykr"):key(), function(self)
	if not self.__is_wpn_fps_sss_unmaykr_init and alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_sss_unmaykr") then
		self.__is_wpn_fps_sss_unmaykr_init = true
		self.__wpn_fps_sss_unmaykr_unit_name = Idstring("units/pd2_dlc_bbq/weapons/molotov_cocktail/wpn_molotov_husk")
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), self.__wpn_fps_sss_unmaykr_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), self.__wpn_fps_sss_unmaykr_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "__clbk_wpn_fps_sss_unmaykr_unit_loaded"))
		else
			self:__clbk_wpn_fps_sss_unmaykr_unit_loaded()
		end
	end
end)

Hooks:PostHook(ShotgunBase, "_fire_raycast", "F_"..Idstring("PostHook:ShotgunBase:_fire_raycast:Super Weapon: Unmaykr"):key(), function(self, __user_unit, __from_pos, __direction)
	if Utils and self.__is_wpn_fps_sss_unmaykr then
		local __unit = safe_spawn_unit(self.__wpn_fps_sss_unmaykr_unit_name, __from_pos, Rotation())
		if __unit then
			local camera = managers.player:player_unit():movement()._current_state._ext_camera
			local __mvec_to = Vector3()
			mvector3.set(__mvec_to, camera:forward())
			mvector3.multiply(__mvec_to, 100)
			mvector3.add(__mvec_to, __unit:position())
			table.insert(self.__wpn_fps_sss_unmaykr_bomb, {
				__dead_t = TimerManager:game():time() + 5,
				__to_pos = __mvec_to,
				__from_pos = __unit:position(),
				__unit = __unit
			})
		end
	end
end)
