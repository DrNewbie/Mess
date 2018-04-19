local _set_func_chk_spawn_shield = CopInventory._chk_spawn_shield
function CopInventory:_chk_spawn_shield(weapon_unit)
	_set_func_chk_spawn_shield(self, weapon_unit)
	if self._unit:base()._tweak_table == "tank" then
		self._shield_unit_name = "units/payday2/vehicles/anim_vehicle_van_swat/anim_vehicle_van_swat"
		self._shield_attach_point = Idstring("a_weapon_right_front")
	end
	if self._shield_unit_name and not alive(self._shield_unit) then
		local module_id = math.random()
		local align_name = self._shield_attach_point or Idstring("a_weapon_left_front")
		local turret_name = "units/payday2/vehicles/gen_vehicle_turret/gen_vehicle_turret"
		local align_obj = self._unit:get_object(align_name)
		self._shield_unit = World:spawn_unit(Idstring(self._shield_unit_name), align_obj:position(), align_obj:rotation())
		self._unit:link(align_name, self._shield_unit, self._shield_unit:orientation_object():name())
		self._shield_unit:set_enabled(false)
		self._shield_unit:base():spawn_module( turret_name, "spawn_turret", module_id )
		self._shield_unit:base():run_module_function( module_id, "base", "activate_as_module", "combatant", "swat_van_turret_module" )
	end
end