if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "bph" then
	return
end


Hooks:PostHook(CopInventory, "_chk_spawn_shield", "GiveSWATTurrettoBulldozerGiveNow", function(self)
	if self._unit and table.index_of(tweak_data.character:enemy_list(), tostring(self._unit:base()._tweak_table)) ~= -1 then
		local align_name = Idstring("a_weapon_right_front")
		local align_object = self._unit:get_object(align_name)
		if align_object then
			self._turret_unit_addon = World:spawn_unit(Idstring("units/pd2_dlc_bph/vehicles/bph_turret/bph_turret_crate"), align_object:position(), align_object:rotation())
			if self._turret_unit_addon and alive(self._turret_unit_addon) and self._turret_unit_addon.base and self._turret_unit_addon:base() then
				self._unit:link(align_name, self._turret_unit_addon, self._turret_unit_addon:orientation_object():name())
				--self._turret_unit_addon:set_enabled(false)
				local module_id = math.random()
				self._turret_unit_addon:base():spawn_module("units/pd2_dlc_bph/vehicles/bph_turret/bph_turret", "rp_bph_turret_crate", module_id)
				self._turret_unit_addon:base():run_module_function(module_id, "base", "activate_as_module", "combatant", "swat_van_turret_module")
			end
		end
	end
end)

Hooks:PreHook(CopDamage, "die", "GiveSWATTurrettoBulldozerKillIt", function(self)
	if self._turret_unit_addon and alive(self._turret_unit_addon) then
		local Tu = self._turret_unit_addon:base()
		if type(Tu._modules) == "table" then
			for module_id, module_entry in pairs(Tu._modules) do
				if module_entry.unit and module_entry.unit.character_damage and not module_entry.unit:character_damage():dead() then
					for _, data in pairs(managers.groupai:state():all_criminals()) do
						if data and alive(data.unit) and data.status ~= "dead" then
							module_entry.unit:character_damage():die(data.unit, "explosion")
							break
						end
					end	
				end
			end
		end
	end
end)