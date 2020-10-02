local mod_ids = Idstring("Gun Melee"):key()
local func4 = "F_"..Idstring("func4:"..mod_ids):key()

Hooks:PostHook(FPCameraPlayerBase, "spawn_melee_item", "F_"..Idstring("PostHook:FPCameraPlayerBase:spawn_melee_item:"..mod_ids):key(), function(self)
	if type(self._melee_item_units) == "table" then
		local ply_unit = managers.player:local_player()
		if ply_unit and ply_unit:inventory() then
			local wep_unit = ply_unit:inventory():equipped_unit()
			if wep_unit and wep_unit:base() then
				local wep_base = wep_unit:base()
				for _, __melee_unit in pairs(self._melee_item_units) do
					local align_obj
					if true then
						__melee_unit:set_visible(false)
						local factory_weapon = tweak_data.weapon.factory[wep_base._factory_id]
						local ids_unit_name = Idstring(factory_weapon.unit)
						local attach_gun = World:spawn_unit(ids_unit_name, Vector3(), Rotation())
						if attach_gun then
							attach_gun:base():set_factory_data(wep_base._factory_id)
							if wep_base._cosmetics then
								attach_gun:base():set_cosmetics_data(wep_base._cosmetics)
							end
							if wep_base._blueprint then
								attach_gun:base():assemble_from_blueprint(wep_base._factory_id, wep_base._blueprint)
							elseif not unit_name then
								attach_gun:base():assemble(wep_base._factory_id)
							end
							attach_gun:base():check_npc()
							attach_gun:base():setup({
								user_unit = self._unit,
								ignore_units = {
									self._unit,
									wep_unit,
									ply_unit,
									attach_gun
								},
								expend_ammo = true,
								autoaim = true,
								alert_AI = true,
								alert_filter = ply_unit:movement():SO_access(),
								timer = managers.player:player_timer()
							})
							attach_gun:set_enabled(true)
							attach_gun:base():on_enabled()
							self[func4] = self[func4] or {}
							self[func4][attach_gun:key()] = attach_gun
							local melee_entry = managers.blackmarket:equipped_melee_weapon()
							local aligns = tweak_data.blackmarket.melee_weapons[melee_entry].align_objects or {"a_weapon_left", "a_weapon_right"}
							for k , v in ipairs(aligns) do
								align_obj = self._parent_unit:camera()._camera_unit:get_object(Idstring(v))
								self._parent_unit:camera()._camera_unit:link(align_obj:name(), attach_gun, attach_gun:orientation_object():name())
							end
						end
					end
				end
			end
		end
	end
end)

Hooks:PostHook(FPCameraPlayerBase, "unspawn_melee_item", "F_"..Idstring("PostHook:FPCameraPlayerBase:unspawn_melee_item:"..mod_ids):key(), function(self)
	if type(self[func4]) == "table" then
		for __key, __unit in pairs(self[func4]) do
			if alive(__unit) then
				__unit:unlink()
				World:delete_unit(__unit)
			end
			self[func4][__key] = nil
		end
	end
end)