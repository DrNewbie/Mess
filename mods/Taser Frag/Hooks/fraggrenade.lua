function FragGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range
	local slot_mask = managers.slot:get_mask("explosion_targets")
	managers.explosion:give_local_player_dmg(pos, range, self._player_damage)
	managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)
	local _params = {
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = self._curve_pow,
		damage = self._damage,
		player_damage = 0,
		ignore_unit = self._unit,
		alert_radius = self._alert_radius,
		user = self:thrower_unit() or self._unit,
		owner = self._unit
	}
	if tostring(self._new_frag) == "frag_taser" then
		_params.damage = 5
		_params._is_taser = true
	end
	local hit_units, splinters = managers.explosion:detect_and_give_dmg(_params)
	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
	self._unit:set_slot(0)
end