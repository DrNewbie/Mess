local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Main1 = "F_"..Idstring("Main1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()

_G[Main1] = _G[Main1] or {}

LocalC4BombBase = LocalC4BombBase or class(FragGrenade)

LocalC4BombBase._play_sound_and_effects = TripMineBase._play_sound_and_effects
LocalC4BombBase._give_explosion_damage = TripMineBase._give_explosion_damage

Hooks:PostHook(LocalC4BombBase, "init", Hook2, function(self)
	self._timer = 365*24*60*60
	self._simulated = false
	self._slot_mask = managers.slot:get_mask("arrow_impact_targets")
	ProjectileBase.create_sweep_data(self)
	_G[Main1][tostring(self._unit:key())] = {
		__unit = self._unit
	}
end)

local mvec1 = Vector3()
local mvec2 = Vector3()

function LocalC4BombBase:update(unit, t, dt)
	if not self._collided then
		self._unit:set_rotation(Rotation(0, 90, 0))
		if not self._simulated then
			self._unit:m_position(mvec1)
			mvector3.set(mvec2, self._velocity * dt)
			mvector3.add(mvec1, mvec2)
			self._unit:set_position(mvec1)
			self._velocity = Vector3(self._velocity.x, self._velocity.y, self._velocity.z - 980 * 0.5 * dt)
		end
		if self._sweep_data then
			self._unit:m_position(self._sweep_data.current_pos)
			local col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask)
			if col_ray and col_ray.unit then
				mvector3.direction(mvec1, self._sweep_data.last_pos, self._sweep_data.current_pos)
				mvector3.add(mvec1, col_ray.position)
				self._unit:set_position(mvec1)
				col_ray.velocity = self._unit:velocity()
				self._collided = true
				_G[Main1][tostring(self._unit:key())].__col_ray = col_ray
			end
			self._unit:m_position(self._sweep_data.last_pos)
		end
	end
end

function LocalC4BombBase:_detonate()

end

function LocalC4BombBase:_explode()
	self:_play_sound_and_effects()
	
	local damage_size = tweak_data.weapon.trip_mines.damage_size * 2
	local player = managers.player:player_unit()
	
	managers.explosion:give_local_player_dmg(self._unit:position(), damage_size, tweak_data.weapon.trip_mines.player_damage)
	self._unit:set_extension_update_enabled(Idstring("base"), false)
	
	local from_pos = self._unit:position() + self._unit:rotation():y() * 10
	local to_pos = from_pos + self._unit:rotation():y() * 500
	
	local slotmask = managers.slot:get_mask("explosion_targets")
	local bodies = World:find_bodies("intersect", "cylinder", from_pos, to_pos, damage_size, slotmask)
	
	local damage = tweak_data.weapon.trip_mines.damage * 10
	
	local characters_hit = {}
	for _, hit_body in pairs(bodies) do
		if alive(hit_body) then
			local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_explosion
			local apply_dmg = hit_body:extension() and hit_body:extension().damage
			local dir, ray_hit = nil
			if character and not characters_hit[hit_body:unit():key()] then
				local com = hit_body:center_of_mass()
				local ray_from = math.point_on_line(from_pos, to_pos, com)
				ray_hit = not World:raycast("ray", ray_from, com, "slot_mask", slotmask, "ignore_unit", {
					hit_body:unit()
				}, "report")
				if ray_hit then
					characters_hit[hit_body:unit():key()] = true
				end
			elseif apply_dmg or hit_body:dynamic() then
				ray_hit = true
			end
			if ray_hit then
				dir = hit_body:center_of_mass()
				mvector3.direction(dir, from_pos, dir)
				if apply_dmg then
					local normal = dir
					local prop_damage = math.min(damage, 200)
					local network_damage = math.ceil(prop_damage * 163.84)
					prop_damage = network_damage / 163.84
					hit_body:extension().damage:damage_explosion(player, normal, hit_body:position(), dir, prop_damage)
					hit_body:extension().damage:damage_damage(player, normal, hit_body:position(), dir, prop_damage)
					if hit_body:unit():id() ~= -1 then
						if player then
							managers.network:session():send_to_peers_synched("sync_body_damage_explosion", hit_body, player, normal, hit_body:position(), dir, math.min(32768, network_damage))
						else
							managers.network:session():send_to_peers_synched("sync_body_damage_explosion_no_attacker", hit_body, normal, hit_body:position(), dir, math.min(32768, network_damage))
						end
					end
				end
				if hit_body:unit():in_slot(managers.game_play_central._slotmask_physics_push) then
					hit_body:unit():push(5, dir * 500)
				end
				if character then
					self:_give_explosion_damage({
						position = from_pos,
						ray = math.UP
					}, hit_body:unit(), damage)
				end
			end
		end
	end
	
	local alert_event = {
		"aggression",
		from_pos,
		tweak_data.weapon.trip_mines.alert_radius,
		self._alert_filter,
		self._unit
	}
	managers.groupai:state():propagate_alert(alert_event)
	
	self._unit:set_slot(0)
end

function LocalC4BombBase:KaBoom()
	local __is_kaboom
	for __key, __c4 in pairs(_G[Main1]) do
		if __c4 and __c4.__unit and __c4.__col_ray and __c4.__unit.base and __c4.__unit:base() then
			__c4.__unit:base():_explode()
			__c4.__unit:base():_detonate()
			__is_kaboom = true
		end
		_G[Main1][__key] = nil
	end
	if managers.player and managers.player:player_unit() and __is_kaboom then
		PlayerStandard.say_line(managers.player:player_unit():base(), "g10")
	end
end

if Network and Network:is_client() then
	tweak_data.blackmarket.projectiles.wpn_prj_four.name_id = "bm_c4_grenade_local_name_not_working"
end