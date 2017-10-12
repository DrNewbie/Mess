ProjectileBase = ProjectileBase or class(UnitBase)

function ProjectileBase.throw_projectile(projectile_type, pos, dir, owner_peer_id)
	local projectile_entry = tweak_data.blackmarket:get_projectile_name_from_index(projectile_type)
	if not ProjectileBase.check_time_cheat(projectile_type, owner_peer_id) then
		return
	end
	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_entry]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local unit = World:spawn_unit(unit_name, pos, Rotation(dir, math.UP))
	if owner_peer_id and managers.network:session() then
		local peer = managers.network:session():peer(owner_peer_id)
		local thrower_unit = peer and peer:unit()

		if alive(thrower_unit) then
			unit:base():set_thrower_unit(thrower_unit)

			if not tweak_entry.throwable and thrower_unit:movement() and thrower_unit:movement():current_state() then
				unit:base():set_weapon_unit(thrower_unit:movement():current_state()._equipped_unit)
			end
		end
	end
	unit:base():throw({
		dir = dir,
		projectile_entry = projectile_entry
	})
	if unit:base().set_owner_peer_id then
		unit:base():set_owner_peer_id(owner_peer_id)
	end
	if projectile_entry == 'rocket_ray_frag_incen' then
		projectile_entry = 'rocket_ray_frag'
		projectile_type = tweak_data.blackmarket:get_index_from_projectile_id(projectile_entry)
		unit:base()._fake_fire = true
	end
	managers.network:session():send_to_peers_synched("sync_throw_projectile", unit:id() ~= -1 and unit or nil, pos, dir, projectile_type, owner_peer_id or 0)
	if tweak_data.blackmarket.projectiles[projectile_entry].impact_detonation then
		unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
		unit:base():create_sweep_data()
	end
	return unit
end