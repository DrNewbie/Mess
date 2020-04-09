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
		local camera = managers.player:player_unit():movement()._current_state._ext_camera
		local __camera_pos = camera:forward()
		local __now = TimerManager:game():time()
		local __now_ids = Idstring(tostring(__now)):key()
		local __offset = {
			Rotation(30, 0, 0),
			Rotation(0, 0, 0),
			Rotation(-30, 0, 0),
		}
		for __i = 1, 3 do
			if not self.__wpn_fps_sss_unmaykr_bomb["M_"..__i.."_"..__now_ids] then
				local __mvec_to = Vector3()
				local __unit = safe_spawn_unit(self.__wpn_fps_sss_unmaykr_unit_name, __from_pos, Rotation())
				if __unit then
					mvector3.set(__mvec_to, __camera_pos + __camera_pos:rotate_with(__offset[__i]))
					mvector3.multiply(__mvec_to, 100)
					mvector3.add(__mvec_to, __unit:position())
					self.__wpn_fps_sss_unmaykr_bomb["M_"..__i.."_"..__now_ids] = {
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
