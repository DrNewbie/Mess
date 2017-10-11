_G.StandaloneFlamethrowerEffect = _G.StandaloneFlamethrowerEffect or {}

function StandaloneFlamethrowerEffect:setup_default(them)
	them._flame_effect = {effect = Idstring("effects/payday2/particles/explosions/flamethrower")}
	them._nozzle_effect = {effect = Idstring("effects/payday2/particles/explosions/flamethrower_nosel")}
	them._pilot_light = {effect = Idstring("effects/payday2/particles/explosions/flamethrower_pilot")}
	them._flame_max_range = 1000
	them._single_flame_effect_duration = 1
	them._distance_to_gun_tip = 50
	them._flamethrower_effect_collection = {}
	return them
end
local mvec1 = Vector3()

function StandaloneFlamethrowerEffect:update(them, t, dt)
	if them._flamethrower_effect_collection ~= nil then
		local flame_effect_dt = them._single_flame_effect_duration / dt
		local flame_effect_distance = them._flame_max_range / flame_effect_dt
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
				mvector3.set(mvec1, effect_entry.position)
				mvector3.add(effect_entry.position, effect_entry.direction * flame_effect_distance)
				local raycast = World:raycast(mvec1, effect_entry.position)
				if raycast ~= nil then
					table.remove(them._flamethrower_effect_collection, _)
				else
					World:effect_manager():move(effect_entry.id, effect_entry.position)
				end
				local effect_distance = mvector3.distance(effect_entry.position, them._m_head_pos + Vector3(0, 0, -80))
				if them._flame_max_range < effect_distance then
					World:effect_manager():kill(effect_entry.id)
				end
			end
		end
	end
end

Hooks:PostHook(HuskPlayerMovement, "_upd_attention_driving", "Update_StandaloneFlamethrowerEffect", function(self, t, dt)
	if self._driver then
		local peer_id = managers.network:session():peer_by_unit(self._unit):id()
		local vehicle_data = managers.player:get_vehicle_for_peer(peer_id)
		local vehicle_unit = vehicle_data.vehicle_unit
		local vehicle_tweak_data = vehicle_unit:vehicle_driving()._tweak_data
		if vehicle_tweak_data.animations.vehicle_id == "bike_1" then
			StandaloneFlamethrowerEffect:update(self, t, dt)
			if t > self._last_fire_time then
				self._last_fire_time = t + 0.05
				StandaloneFlamethrowerEffect:_spawn_muzzle_effect(self)
			end
		end
	end
end)

function StandaloneFlamethrowerEffect:_spawn_muzzle_effect(them, from_pos)
	local mvector3_add = mvector3.add
	local mvector3_copy = mvector3.copy
	local mvector3_negate = mvector3.negate
	local mvector3_rotate_with = mvector3.rotate_with
	local mvector3_normalize = mvector3.normalize	
	local direction = mvector3_copy(them._m_head_pos)
	mvector3_rotate_with(direction, them._m_rot)
	mvector3_add(direction, them._m_pos)
	mvector3_negate(direction)
	mvector3_normalize(direction)
	
	from_pos = from_pos or Vector3(0, 0, 0)
	direction = direction or Vector3(0, 0, 0)
	them = self:setup_default(them)
	local from = from_pos + direction * 50
	local nozzle_pos = them._m_head_pos + Vector3(0, 0, -80)
	local attach_obj = them._unit
	local _flame_effect_id = World:effect_manager():spawn({
		effect = them._flame_effect.effect,
		position = nozzle_pos,
		normal = math.UP
	})
	table.insert(them._flamethrower_effect_collection, {
		been_alive = false,
		id = _flame_effect_id,
		position = nozzle_pos,
		direction = direction
	})
end

Hooks:PostHook(HuskPlayerMovement, "post_init", "Init_FlamethrowerEffectExtension", function(self, ...)
	self._last_fire_time = 0
end)