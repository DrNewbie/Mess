local _f_NewShotgunBase_fire_raycast = NewShotgunBase._fire_raycast

function NewShotgunBase:_fire_raycast(user_unit, from_pos, direction, ...)
	if self._muzzle_effect and self._muzzle_effect:key() == "70813580e1edde68" then
		self:_spawn_muzzle_effect_clnoe(from_pos, direction)
	end
	return _f_NewShotgunBase_fire_raycast(self, user_unit, from_pos, direction, ...)
end

function NewShotgunBase:_spawn_muzzle_effect_clnoe(from_pos, direction)
	local from = from_pos + direction * 50
	local nozzle_obj = self._unit:get_object(Idstring("fire"))
	local nozzle_pos = nozzle_obj:position()
	local attach_obj = self._unit
	local effect_id = World:effect_manager():spawn({
		effect = Idstring("effects/payday2/particles/explosions/flamethrower"),
		position = nozzle_pos,
		normal = math.UP
	})
	self._flamethrower_effect_collection = self._flamethrower_effect_collection or {}
	table.insert(self._flamethrower_effect_collection, {
		id = effect_id,
		position = nozzle_pos,
		direction = direction,
		been_alive = false
	})
end