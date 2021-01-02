local p_load = "packages/load_melee_crucible_doom_eternal"
if PackageManager:package_exists(p_load) then
	if not PackageManager:loaded(p_load) then
		PackageManager:load(p_load)
	end
end

local old_do_melee_damage = PlayerStandard._do_melee_damage

function PlayerStandard:_do_melee_damage(t, bayonet_melee, melee_hit_ray, melee_entry, ...)
	melee_entry = melee_entry or managers.blackmarket:equipped_melee_weapon()
	local col_ray = self:_calc_melee_hit_ray(t, 20)
	if melee_entry and melee_entry == "crucible_doom_eternal" and col_ray and col_ray.unit and alive(col_ray.unit) and managers.enemy:is_enemy(col_ray.unit) then
		local hit_unit = col_ray.unit
		local hit_pos = hit_unit:position() + Vector3(0, 0, 50)
		managers.explosion:detect_and_give_dmg({
			push_units = false,
			player_damage = 0,
			hit_pos = hit_pos,
			range = 150,
			collision_slotmask = managers.slot:get_mask("explosion_targets"),
			curve_pow = 3,
			damage = math.huge,
			ignore_unit = self._unit,
			alert_radius = 0,
			user = self._unit
		})
	end
	return col_ray
end