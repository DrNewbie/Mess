local old_func1 = "F_"..Idstring("Symmetra:valid_look_at_placement"):key()
local old_func2 = "F_"..Idstring("Symmetra:use_sentry_gun"):key()

PlayerEquipment[old_func1] = PlayerEquipment[old_func1] or PlayerEquipment.valid_look_at_placement
PlayerEquipment[old_func2] = PlayerEquipment[old_func2] or PlayerEquipment.use_sentry_gun

function PlayerEquipment:valid_look_at_placement(equipment_data, ...)
	equipment_data = equipment_data or managers.player:selected_equipment()
	local __ray = self[old_func1](self, equipment_data, ...)
	if tostring(equipment_data.use_function) == "use_sentry_gun" then
		if __ray and equipment_data and self._dummy_unit then
			local pos = __ray.position
			local rot = self._unit:movement():m_head_rot()
			rot = Rotation(__ray.normal, math.UP)
			self._dummy_unit:set_position(pos)
			self._dummy_unit:set_rotation(rot)
			if alive(self._dummy_unit) then
				self._dummy_unit:set_enabled(true)
			end
		end
	end
	return __ray
end

function PlayerEquipment:use_sentry_gun(selected_index, unit_idstring_index, ...)
	local __ans = self[old_func2](self, selected_index, unit_idstring_index, ...)
	if __ans then
		return __ans
	else
		if self._sentrygun_placement_requested then
			return
		end
		local _valid_look_at_placement = false
		local ray = self:valid_shape_placement()	
		if not ray and managers.player:selected_equipment() then
			_valid_look_at_placement = true
			ray = self:valid_look_at_placement(managers.player:selected_equipment())
		end
		if ray and self:_can_place("sentry_gun") then
			local pos = ray.position
			local rot = self:_m_deploy_rot()
			if _valid_look_at_placement then
				local rot_pitch = math.round(rot:pitch())
				if rot_pitch < 66 and rot_pitch > -66 then
					rot_pitch = 90
				elseif rot_pitch >= 66 then
					rot_pitch = 180
				else
					rot_pitch = 0
				end
				rot = Rotation(rot:yaw(), rot_pitch, 0)
			else
				rot = Rotation(rot:yaw(), 0, 0)
			end
			managers.statistics:use_sentry_gun()
			local ammo_level = managers.player:upgrade_value("sentry_gun", "extra_ammo_multiplier", 1)
			local armor_multiplier = 1 + managers.player:upgrade_value("sentry_gun", "armor_multiplier", 1) - 1 + managers.player:upgrade_value("sentry_gun", "armor_multiplier2", 1) - 1
			local can_switch_fire_mode = managers.player:has_category_upgrade("sentry_gun", "ap_bullets")
			local equipment_name = managers.player:equipment_in_slot(selected_index)
			local fire_mode_index = can_switch_fire_mode and managers.player:get_equipment_setting(equipment_name, "fire_mode") or 1
			if Network:is_client() then
				managers.network:session():send_to_host("place_sentry_gun", pos, rot, selected_index, self._unit, unit_idstring_index, ammo_level, fire_mode_index)
				self._sentrygun_placement_requested = true
				return false
			else
				local shield = managers.player:has_category_upgrade("sentry_gun", "shield")
				local sentry_gun_unit, spread_level, rot_level = SentryGunBase.spawn(self._unit, pos, rot, managers.network:session():local_peer():id(), false, unit_idstring_index)
				if sentry_gun_unit then
					self:_sentry_gun_ammo_cost(sentry_gun_unit:id())
					local fire_rate_reduction = managers.player:upgrade_value("sentry_gun", "fire_rate_reduction", 1)
					managers.network:session():send_to_peers_synched("from_server_sentry_gun_place_result", managers.network:session():local_peer():id(), selected_index, sentry_gun_unit, rot_level, spread_level, shield, ammo_level, fire_mode_index)
					sentry_gun_unit:event_listener():call("on_setup", true)
					sentry_gun_unit:base():post_setup(fire_mode_index)
				else
					return false
				end
			end
			return true
		end
		return false
	end
end