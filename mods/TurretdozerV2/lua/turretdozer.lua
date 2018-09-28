Hooks:PostHook(CopInventory, "_chk_spawn_shield", "GiveSWATTurrettoBulldozerGiveNow", function(self)
	if self._unit and self._unit:base()._tweak_table == "tank" then
		local align_name = Idstring("a_weapon_right_front")
		local align_object = self._unit:get_object(align_name)
		if align_object then
			local Tu = World:spawn_unit(Idstring("units/payday2/vehicles/gen_vehicle_turret/gen_vehicle_turret"), align_object:position(), Rotation(0, 0, 1))
			if Tu and Tu.base then
				Tu:movement()._hacked_stop_snd_event = nil
				Tu:movement()._hacked_start_snd_event = nil
				local is_host = Network:is_server() or Global.game_settings.single_player
				self._turret_unit_addon = Tu
				self._unit:link(align_object:name(), Tu, Tu:orientation_object():name())
				local extension = Tu["base"](Tu)
				extension["activate_as_module"](extension, "combatant", "swat_van_turret_module")
			end
		end
	end
end)

Hooks:PostHook(CopBrain, "update", "GiveSWATTurrettoBulldozerActiveIt", function(self, unit, t, dt)
	if not managers.groupai:state():whisper_mode() then
		if self._turret_unit_addon then		
			if self._turret_unit_addon:movement():is_inactivated() then
				if self._reboot_my_turret then
					self._reboot_my_turret = self._reboot_my_turret - dt
					if self._reboot_my_turret <= 0 then
						self._reboot_my_turret = nil
						self._turret_unit_addon:movement():on_activated()					
					end
				else
					self._reboot_my_turret = 5
				end
			end
		end
	end
end)

Hooks:PostHook(CopBrain, "pre_destroy", "GiveSWATTurrettoBulldozerKillIt", function(self)
	if self._turret_unit_addon then
		self._turret_unit_addon:base():destroy()
		if self._turret_unit_addon then
			self._turret_unit_addon:set_slot(0)
		end
		self._turret_unit_addon = nil
	end
end)

if not PackageManager:loaded("levels/narratives/h_firestarter/stage_3/world/world") then
	PackageManager:load("levels/narratives/h_firestarter/stage_3/world/world")
end