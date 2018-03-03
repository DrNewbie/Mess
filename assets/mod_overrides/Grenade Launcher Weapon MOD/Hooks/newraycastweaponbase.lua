local GrenadeLauncherWeaponMOD_FIREWEAPON = NewRaycastWeaponBase.fire

function NewRaycastWeaponBase:fire(expl_pos, expl_dir, ...)
	if self:fire_mode() == "single" then
		for _, v in pairs(self._unit:base()._blueprint or {}) do
			if v == "wpn_grenade_launcher_mod" then
				local _, _, total, _ = self._unit:base():ammo_info()
				if total >= 10 then
					self._unit:base():set_ammo_total(total - 10)
					managers.hud:set_ammo_amount(managers.player:equipped_weapon_index(), self._unit:base():ammo_info())
					if Network:is_client() then
						local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id("launcher_frag")
						managers.network:session():send_to_host("request_throw_projectile", projectile_type_index, expl_pos + Vector3(0, 0, 10), expl_dir)
					else
						local unit = ProjectileBase.throw_projectile("launcher_frag", expl_pos + Vector3(0, 0, 10), expl_dir, managers.network:session():local_peer():id())
						if unit then
							unit:base():set_weapon_unit(managers.player:equipped_weapon_unit())
						end
					end
				end
				break
			end
		end
	end
	return GrenadeLauncherWeaponMOD_FIREWEAPON(self, expl_pos, expl_dir, ...)
end