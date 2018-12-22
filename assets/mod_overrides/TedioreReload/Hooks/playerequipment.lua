if (Net and Net:IsHost()) or (Global.game_settings and Global.game_settings.single_player) then
	function PlayerEquipment:throw_and_reload_set(them, wep_unit)
		self._throw_and_reload = {
			wep_unit = wep_unit,
			them = them
		}
	end

	function PlayerEquipment:throw_and_reload()
		if not self._throw_and_reload or not self._throw_and_reload.wep_unit then
			self._throw_and_reload = nil
			return
		end
		local them = self._throw_and_reload.them
		local wep_unit = self._throw_and_reload.wep_unit
		local wep_base = wep_unit:base()
		self._throw_and_reload = nil
		
		local throw_unit = ProjectileBase.throw_projectile("wpn_prj_hur", them:get_fire_weapon_position(), them:get_fire_weapon_direction(), managers.network:session():local_peer():id())
		if throw_unit then
			local align_obj = throw_unit:get_object(Idstring("g_axe"))
			
			local factory_weapon = tweak_data.weapon.factory[wep_base._factory_id]
			local ids_unit_name = Idstring(factory_weapon.unit)
			local throw_gun = World:spawn_unit(ids_unit_name, Vector3(), Rotation())
			if throw_gun then
				throw_gun:base():set_factory_data(wep_base._factory_id)
				throw_gun:base():set_cosmetics_data(nil)
				throw_gun:base():assemble(wep_base._factory_id)
				throw_gun:base():check_npc()
				throw_gun:base():setup({
					user_unit = them._unit,
					ignore_units = {
						them._unit,
						wep_unit,
						throw_unit,
						throw_gun
					},
					expend_ammo = true,
					autoaim = true,
					alert_AI = true,
					alert_filter = managers.player:local_player():movement():SO_access(),
					timer = managers.player:player_timer()
				})
				throw_gun:set_enabled(true)
				throw_gun:base():on_enabled()
				
				throw_unit:set_visible(false)
				if throw_unit.spawn_manager and throw_unit:spawn_manager() and throw_unit:spawn_manager():linked_units() then
					for unit_id, _ in pairs(throw_unit:spawn_manager():linked_units()) do
						local unit_entry = throw_unit:spawn_manager():spawned_units()[unit_id]
						if unit_entry and alive(unit_entry.unit) then
							unit_entry.unit:set_visible(false)
						end
					end
				end
				local ammo_base = wep_base._reload_ammo_base or wep_base:ammo_base()
				local ammo_in_clip = ammo_base:get_ammo_remaining_in_clip()
				local get_ammo_total = ammo_base:get_ammo_total()
				ammo_base:set_ammo_total(math.max(get_ammo_total - ammo_in_clip, 0))
				wep_base:on_reload()
				throw_unit:link(align_obj:name(), throw_gun, throw_gun:orientation_object():name())
				throw_unit:base()._throw_and_reload = throw_gun
				throw_unit:base()._throw_and_reload_dt = 3				
				throw_unit:base()._throw_and_reload_dmg = ammo_in_clip * 100
				local inventory = managers.player:player_unit():inventory()
				if inventory then
					for index, weapon in pairs(inventory:available_selections()) do
						managers.hud:set_ammo_amount(index, weapon.unit:base():ammo_info())
					end
				end
				return true
			end
		end
	end

	local HookThatEquipmentPlyThrowProjectile = PlayerEquipment.throw_projectile

	local HookThatEquipmentPlyThrowGrenade = PlayerEquipment.throw_grenade

	local HookThatEquipmentPlyThrowFlashGrenade = PlayerEquipment.throw_flash_grenade

	function PlayerEquipment:throw_projectile(...)
		return self:throw_and_reload() or HookThatEquipmentPlyThrowProjectile(self, ...)
	end

	function PlayerEquipment:throw_grenade(...)
		return self:throw_and_reload() or HookThatEquipmentPlyThrowGrenade(self, ...)
	end

	function PlayerEquipment:throw_flash_grenade(...)
		return self:throw_and_reload() or HookThatEquipmentPlyThrowFlashGrenade(self, ...)
	end
end