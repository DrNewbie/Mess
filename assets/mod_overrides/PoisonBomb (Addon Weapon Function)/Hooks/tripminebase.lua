local mod_ids = Idstring("PoisonBomb (Addon Weapon Function)"):key()
local func01 = "F_"..Idstring("func01:"..mod_ids):key()

local __rnd_n2p = function ()
	return math.random(360)*((math.random(1,2)*2)-3)
end

TripMineBase[func01] = function(pos, rot, sensor_upgrade)
	if not DB:has(Idstring("unit"), Idstring("units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine_husk")) then
		return
	end
	local __tripmine = World:spawn_unit(Idstring("units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine_husk"), pos, Vector3(__rnd_n2p(), __rnd_n2p(), __rnd_n2p()))
	if __tripmine then
		--Init
		__tripmine:base():setup(sensor_upgrade)
		--Active
		__tripmine:base()._active = true
		__tripmine:set_extension_update_enabled(Idstring("base"), true)
		--Add
		local from_pos = __tripmine:position() + __tripmine:rotation():y() * 10
		local to_pos = from_pos + __tripmine:rotation():y() * __tripmine:base()._init_length
		local ray = __tripmine:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
		__tripmine:base()._length = math.clamp(ray and ray.distance + 10 or __tripmine:base()._init_length, 0, __tripmine:base()._init_length)
		__tripmine:anim_set_time(__tripmine:base()._ids_laser, __tripmine:base()._length / __tripmine:base()._init_length)
		__tripmine:base()._activate_timer = 3
		mvector3.set(__tripmine:base()._ray_from_pos, __tripmine:base()._position)
		mvector3.set(__tripmine:base()._ray_to_pos, __tripmine:base()._forward)
		mvector3.multiply(__tripmine:base()._ray_to_pos, __tripmine:base()._length)
		mvector3.add(__tripmine:base()._ray_to_pos, __tripmine:base()._ray_from_pos)
		--Flyable
		local function __on_collision(self)
		
		end
		__tripmine:base()._on_collision = __on_collision
		local velocity = rot
		velocity = velocity * tweak_data.projectiles["launcher_frag"].launch_speed  
		velocity = Vector3(velocity.x, velocity.y, velocity.z + 50)
		__tripmine:base()._velocity = velocity
		__tripmine:base()._sweep_data = {
			slot_mask = managers.slot:get_mask("world_geometry")
		}
		__tripmine:base()._sweep_data.current_pos = __tripmine:position()
		__tripmine:base()._sweep_data.last_pos = mvector3.copy(__tripmine:base()._sweep_data.current_pos)
		local function __update(self, unit, t, dt)
			if not self._collided then
				self._sweep_data.old_last_pos = self._sweep_data.last_pos
				ProjectileBase.update(self, unit, t, dt)
			else
				self._unit:set_position(self._sweep_data.old_last_pos)
				self._position = self._sweep_data.old_last_pos
				self._unit:set_position(self._unit:position())
				self._unit:set_enabled(false)
				self._unit:set_enabled(true)
				self.explode(self)
			end
		end
		__tripmine:base().update = __update
		local __mass = math.max(2 * (1 + math.min(0, rot.z)), 1)
		__tripmine:push_at(__mass, velocity, __tripmine:position())
		--Boom
		local function __explode(self, col_ray)
			local damage_size = tweak_data.weapon.trip_mines.damage_size
			local player = managers.player:player_unit()
			local weapon_unit = player:inventory():equipped_unit()
			self._unit:set_extension_update_enabled(Idstring("base"), false)
			self._deactive_timer = 5
			self:_play_sound_and_effects()
			local old_col_ray_unit = col_ray.unit
			local slotmask = managers.slot:get_mask("explosion_targets")
			local characters_hit = {}
			local bodies = World:find_bodies("intersect", "sphere", self._position, damage_size * 1.5, slotmask)
			for _, hit_body in pairs(bodies) do
				local character = hit_body:unit():character_damage() and hit_body:unit():character_damage().damage_dot and not hit_body:unit():character_damage():dead()
				if character and not characters_hit[hit_body:unit():key()] then
					characters_hit[hit_body:unit():key()] = true
					col_ray.unit = hit_body:unit()
					PoisonBulletBase:give_damage_dot(col_ray, weapon_unit, player, 10, true, "bow_poison_arrow")
					managers.dot:add_doted_enemy(col_ray.unit, TimerManager:game():time(), weapon_unit, 10, 3, true, "poison", "bow_poison_arrow")
				end
			end
			col_ray.unit = old_col_ray_unit
			managers.explosion:play_sound_and_effects(
				self._position,
				math.UP,
				1,
				CarryData.POOF_CUSTOM_PARAMS
			)
			local alert_event = {
				"aggression",
				self._position,
				tweak_data.weapon.trip_mines.alert_radius,
				self._alert_filter,
				player
			}
			managers.groupai:state():propagate_alert(alert_event)
			self._unit:set_slot(0)
		end		
		__tripmine:base()._explode = __explode
		local function old_explode(self)
			self:_explode({
				ray = self._forward,
				position = self._position
			})
		end
		__tripmine:base().explode = old_explode
		local function __bullet_hit(self)
			
		end
		__tripmine:base().bullet_hit = __bullet_hit
		return __tripmine
	end
	return
end