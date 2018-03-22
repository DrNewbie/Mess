local mvec1 = Vector3()
local mvec2 = Vector3()
local mrot1 = Rotation()

local RCWeapon_ProjectileBase_update = ProjectileBase.update

function ProjectileBase:update(unit, t, dt)
	if self._cop_throw_projectile then
		self._slot_mask = managers.slot:get_mask("bullet_impact_targets_no_police")
		self._sweep_data.slot_mask = self._slot_mask
		if not self._simulated and not self._collided then
			self._unit:m_position(mvec1)
			mvector3.set(mvec2, self._velocity * dt)
			mvector3.add(mvec1, mvec2)
			self._unit:set_position(mvec1)
			if self._orient_to_vel then
				mrotation.set_look_at(mrot1, mvec2, math.UP)
				self._unit:set_rotation(mrot1)
			end
			self._velocity = Vector3(self._velocity.x, self._velocity.y, self._velocity.z - 980 * dt)
		end
		if self._sweep_data and not self._collided then
			self._unit:m_position(self._sweep_data.current_pos)
			local col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask)
			local ally_mask = managers.slot:get_mask("all_criminals")
			local is_boom = false
			if col_ray and col_ray.unit and col_ray.unit:in_slot(ally_mask) then
				is_boom = true			
			end
			if managers.player:player_unit() and 150 > mvector3.distance(self._sweep_data.current_pos, managers.player:player_unit():position()) then
				is_boom = true
				col_ray = type(col_ray) == "table" and col_ray or {}
				col_ray.unit = managers.player:player_unit()
			end
			if is_boom then
				self._collided = true
				self:_on_collision(col_ray)
			end
			self._unit:m_position(self._sweep_data.last_pos)
		end
		return
	else
		RCWeapon_ProjectileBase_update(self, unit, t, dt)
	end
end

function ProjectileBase:throw_projectile_alt(projectile_type, pos, dir)
	projectile_type = tostring(projectile_type)
	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	if not tweak_entry then
		return
	end
	local unit_name = Idstring(tweak_entry.unit)
	local unit = World:spawn_unit(unit_name, pos, Rotation(dir, math.UP))
	if unit and unit:base() then
		unit:base()._cop_throw_projectile = true
		unit:base():throw({
			dir = dir,
			projectile_entry = projectile_type
		})
		local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)
		managers.network:session():send_to_peers_synched("sync_throw_projectile", unit:id() ~= -1 and unit or nil, pos, dir, projectile_type_index, owner_peer_id or 0)
		if tweak_data.blackmarket.projectiles[projectile_type].impact_detonation then
			unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
			unit:base():create_sweep_data()
		end
	end
	return unit
end