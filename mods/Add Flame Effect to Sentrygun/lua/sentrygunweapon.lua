local _f_SentryGunWeapon_fire_raycast = SentryGunWeapon._fire_raycast

function SentryGunWeapon:_fire_raycast(from_pos, direction, shoot_player, target_unit)
	if (managers.network and managers.network:session() and 
		managers.network:session():local_peer() and 
		self._owner == managers.network:session():local_peer():unit()) or not managers.network then
		self:_spawn_muzzle_effect(from_pos, direction)
	end
	return _f_SentryGunWeapon_fire_raycast(self, from_pos, direction, shoot_player, target_unit)
end

local _f_SentryGunWeapon_update = SentryGunWeapon.update

function SentryGunWeapon:update(unit, t, dt)
	_f_SentryGunWeapon_update(self, unit, t, dt)
	if (managers.network and managers.network:session() and 
		managers.network:session():local_peer() and 
		self._owner == managers.network:session():local_peer():unit()) or not managers.network then
		_g_FlamethrowerEffectExtension_update(self, unit, t, dt)
	end
end

function SentryGunWeapon:_spawn_muzzle_effect(from_pos, direction)
	local from = from_pos + direction * 50
	local nozzle_obj = self._unit:get_object(Idstring("fire"))
	local nozzle_pos = nozzle_obj:position()
	local attach_obj = self._unit
	local effect_id = World:effect_manager():spawn({
		effect = Idstring("effects/payday2/particles/explosions/flamethrower"),
		position = nozzle_pos,
		normal = math.UP
	})
	self._last_fire_time = managers.player:player_timer():time()
	self._flamethrower_effect_collection = self._flamethrower_effect_collection or {}
	table.insert(self._flamethrower_effect_collection, {
		id = effect_id,
		position = nozzle_pos,
		direction = direction,
		been_alive = false
	})
end

local _mvec1 = Vector3()
function _g_FlamethrowerEffectExtension_update(them, unit, t, dt)
	if them._flamethrower_effect_collection ~= nil then
		local _flame_max_range = 1000
		local _single_flame_effect_duration = 3
		local flame_effect_dt = _single_flame_effect_duration / dt
		local flame_effect_distance = _flame_max_range / flame_effect_dt
		for _, effect_entry in pairs(them._flamethrower_effect_collection) do
			local do_continue = true
			if World:effect_manager():alive(effect_entry.id) == false then
				if effect_entry.been_alive == true then
					World:effect_manager():kill(effect_entry.id)
					table.remove(them._flamethrower_effect_collection, _)
					do_continue = false
				end
			elseif effect_entry.been_alive == false then
				effect_entry.been_alive = true
			end
			if do_continue == true then
				mvector3.set(_mvec1, effect_entry.position)
				mvector3.add(effect_entry.position, effect_entry.direction * flame_effect_distance)
				local raycast = World:raycast(_mvec1, effect_entry.position)
				if raycast ~= nil then
					table.remove(them._flamethrower_effect_collection, _)
				else
					World:effect_manager():move(effect_entry.id, effect_entry.position)
				end
				local effect_distance = mvector3.distance(effect_entry.position, unit:position())
				if effect_distance > _flame_max_range then
					World:effect_manager():kill(effect_entry.id)
				end
			end
		end
	end
end