local func1 = "F_"..Idstring("func1:ChainSawBulletTrail"):key()

function PlayerManager:set_throw_gun_data(data)
	self[func1] = self[func1] or {}
	local __x_key = "M"..Idstring(tostring(math.random()).."_"..tostring(data)):key()
	self[func1][__x_key] = data
	return
end

function PlayerManager:get_throw_gun_data()
	return self[func1] or {}
end

function PlayerManager:remove_throw_gun_data(__x_key)
	self[func1] = self[func1] or {}
	self[func1][__x_key] = nil
	return
end

Hooks:PostHook(PlayerStandard, "init", "F_"..Idstring("PostHook:PlayerStandard:init:ChainSawBulletTrail"):key(), function(self, t, dt)
	local factory_weapon = tweak_data.weapon.factory["wpn_fps_saw"]
	local ids_unit_name = Idstring(factory_weapon.unit)	
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
	end
end)

local function ray_table_contains(__table, unit)
	for i, hit in pairs(__table) do
		if hit.unit == unit then
			return true
		end
	end
	return false
end

local function ray_copy(__table, ray)
	for i, hit in pairs(__table) do
		if hit.unit == ray.unit then
			hit.body = ray.body
			hit.distance = ray.distance
			mvector3.set(hit.hit_position, ray.hit_position)
			mvector3.set(hit.normal, ray.normal)
			mvector3.set(hit.position, ray.position)
			mvector3.set(hit.ray, ray.ray)
		end
	end
end

Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PostHook:PlayerStandard:update:ChainSawBulletTrail"):key(), function(self, t, dt)
	local _wep_base = alive(self._equipped_unit) and self._equipped_unit:base() or nil
	local __throw_gun_data = managers.player:get_throw_gun_data()
	if Utils and _wep_base and type(__throw_gun_data) == "table" then
		for __x_key, __x_data in pairs(__throw_gun_data) do
			if type(__x_data.__dead_t) == "number" then
				if t > __x_data.__dead_t then
					__throw_gun_data[__x_key].__dead_t = nil
				else
					if __x_data.__unit and alive(__x_data.__unit) then
						local __mvec1 = __x_data.__to_pos - __x_data.__from_pos
						local __mvec2 = __x_data.__unit:position()
						local __last_pos = __x_data.__unit:position()
						local __mrot1 = Rotation()
						mvector3.normalize(__mvec1)
						mvector3.add(__mvec2, __mvec1 * 40)
						__x_data.__unit:set_position(__mvec2)
						__x_data.__unit:set_local_position(__mvec2)						
						mrotation.set_look_at(__mrot1, __mvec1, math.UP)
						__x_data.__unit:set_rotation(__mrot1)
						__x_data.__unit:set_moving(2)
						local __col_ray = World:raycast_all("ray", __last_pos, __mvec2, "slot_mask", managers.slot:get_mask("bullet_impact_targets"), "ignore_unit", {self._equipped_unit, self._unit}, "ray_type", "body bullet lock")
						local __hits = {}
						if type(__col_ray) == "table" then
							for i, hit in pairs(__col_ray) do
								if type(hit) == "table" and hit.unit then
									if not ray_table_contains(__hits, hit.unit) then
										table.insert(__hits, hit)
									elseif hit.unit:character_damage() and hit.unit:character_damage().is_head and hit.unit:character_damage():is_head(hit.body) then
										ray_copy(__hits, hit)
									end
								end
							end
							for i, hit in pairs(__hits) do
								SawHit:on_collision(hit, self._equipped_unit, self._unit, 1, __mrot1)
							end
							if #__col_ray > 0 then
								__throw_gun_data[__x_key].__dead_t = 0.5
							end
						end
					end
				end
			else
				if __x_data.__unit and alive(__x_data.__unit) then
					World:delete_unit(__x_data.__unit)
					managers.player:remove_throw_gun_data(__x_key)
				end
			end
		end
	end
end)