Hooks:PostHook(FragGrenade, "_detonate", "rocket_ray_frag_incen_detonate", function(self, tag, unit, body, other_unit, other_body, position, normal, ...)
	if tostring(self._tweak_projectile_entry) == 'rocket_ray_frag_incen' then
		local grenade_entry = self._tweak_projectile_entry or "frag"
		local tweak_entry = tweak_data.projectiles[grenade_entry]
		if tweak_entry.incendiary_fire_arbiter then
			local position = self._unit:position()
			local rotation = self._unit:rotation()
			local data = tweak_entry.incendiary_fire_arbiter
			EnvironmentFire.spawn(position, rotation, data, normal, self._thrower_unit, 0, 1)
			local _fire = World:spawn_unit(Idstring("units/pd2_dlc_bbq/weapons/molotov_cocktail/wpn_molotov_third"), unit:position(), unit:rotation())
			_fire:base():_detonate(normal)
		end
	end
end)