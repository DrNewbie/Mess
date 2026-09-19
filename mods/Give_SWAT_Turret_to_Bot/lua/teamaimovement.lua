function TeamAIMovement:GiveSWATTurrettoBotSpawnUnit(ids_tu)
	if self._unit then
		local hhead_align = self._unit:get_object(Idstring("Head"))
		if hhead_align then
			local Tu = World:spawn_unit(ids_tu, hhead_align:position(), Rotation(0, 0, 1))
			if Tu and Tu.base then
				Tu:character_damage()._invulnerable = true
				Tu:movement()._hacked_stop_snd_event = nil
				Tu:movement()._hacked_start_snd_event = nil
				local is_host = Network:is_server() or Global.game_settings.single_player
				self._turret_unit_addon = Tu
				self._unit:link(hhead_align:name(), Tu, Tu:orientation_object():name())
				local extension = Tu["base"](Tu)
				extension["activate_as_module"](extension, "combatant", "swat_van_turret_module")
				if is_host then
					Tu:movement():set_team(managers.groupai:state():team_data(tweak_data.levels:get_default_team_ID("player")))
				end
			end
		end
	end
end

Hooks:PostHook(TeamAIMovement, "update", "GiveSWATTurrettoBotUpdatePostHook", function(self, unit, t, dt)
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

Hooks:PostHook(TeamAIMovement, "check_visual_equipment", "GiveSWATTurrettoBotPostHook", function(self)
	if managers.dyn_resource then
		local tu = Idstring("units/payday2/vehicles/gen_vehicle_turret/gen_vehicle_turret")
		self:GiveSWATTurrettoBotSpawnUnit(tu)
	end
end)

Hooks:PostHook(TeamAIMovement, "pre_destroy", "GiveSWATTurrettoBotKillTurret", function(self)
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