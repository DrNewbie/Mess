local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local hook1 = "F"..Idstring("hook1::"..mod_ids):key()
local hook2 = "F"..Idstring("hook2::"..mod_ids):key()
local hook3 = "F"..Idstring("hook3::"..mod_ids):key()

local function __hookthis(__wep)
	if not __wep or not alive(__wep) or not __wep:base() or not __wep:base().charm or __wep:base().charm_addon then
	
	else
		local factory_weapon = tweak_data.weapon.factory[__wep:base()._factory_id]
		if factory_weapon then
			local ids_unit_name = Idstring(factory_weapon.unit)
			local align_obj = __wep:base().charm:get_object(Idstring("a_charm"))
			if align_obj then
				managers.dyn_resource:load(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, function()
					local throw_gun = World:spawn_unit(ids_unit_name, __wep:base().charm:position(), Rotation())
					if throw_gun then
						throw_gun:base():set_factory_data(__wep:base()._factory_id)
						throw_gun:base():set_cosmetics_data(__wep:base()._cosmetics)
						throw_gun:base():assemble_from_blueprint(__wep:base()._factory_id, __wep:base()._blueprint)
						throw_gun:base():check_npc()
						throw_gun:base():setup({
							ignore_units = {
								throw_gun
							}
						})
						throw_gun:base():set_visibility_state(true)
						throw_gun:base():on_enabled()
						__wep:base().charm_addon = throw_gun
						__wep:base().charm:link(align_obj:name(), throw_gun, throw_gun:orientation_object():name())
						__wep:base().charm:set_visible(false)
						throw_gun:set_local_rotation(Rotation(0, 180, 180))

						local weapon_parts = throw_gun:base()._parts
						if weapon_parts then
							local part_names = table.map_keys(weapon_parts)
							for i = 1, #part_names do
								if part_names[i]:find("charm") then
									local charm = weapon_parts[part_names[i]].unit
									if charm then
										local charm_base = charm:get_object(Idstring("g_base"))
										local charm_ring = charm:get_object(Idstring("a_charm"))
										local charm_top = charm:get_object(Idstring("g_charm_top"))
										local charm_body = charm:get_object(Idstring("g_charm"))
										if not charm_body or not charm_top or not charm_ring then
										
										else
											local throw_gun_2 = World:spawn_unit(ids_unit_name, __wep:base().charm:position(), Rotation())
											if throw_gun_2 then
												throw_gun_2:base():set_factory_data(__wep:base()._factory_id)
												throw_gun_2:base():set_cosmetics_data(__wep:base()._cosmetics)
												throw_gun_2:base():assemble_from_blueprint(__wep:base()._factory_id, __wep:base()._blueprint)
												throw_gun_2:base():check_npc()
												throw_gun_2:base():setup({
													ignore_units = {
														throw_gun_2,
														throw_gun
													}
												})
												throw_gun_2:base():set_visibility_state(true)
												throw_gun_2:base():on_enabled()
												charm:link(align_obj:name(), throw_gun_2, throw_gun_2:orientation_object():name())
												throw_gun_2:set_local_rotation(Rotation(0, 180, 180))
												charm_body:link(charm_ring)
												throw_gun:base().charm = charm
												throw_gun:base().charm_top = charm_ring
												throw_gun:base().scanned = true
											end										
										end
									end
								end
							end
						end
					end
				end)
			end
		end
	end
	return
end

Hooks:PostHook(CharmManager, "link_charms", hook1, function(self, __wep)
	__hookthis(__wep)
	if __wep:base()._second_gun and not __wep:base()._second_gun_charms_fix then
		__wep:base()._second_gun_charms_fix = true
		__wep:base()._second_gun:base():set_cosmetics_data(__wep:base()._cosmetics)
		__wep:base()._second_gun:base():assemble_from_blueprint(__wep:base()._factory_id, __wep:base()._blueprint)
		self:link_charms(__wep:base()._second_gun)
	end
end)

Hooks:PostHook(CharmManager, "_update_player_charm", hook2, function(self, t, dt, weapon)
	if weapon and weapon:base() and weapon:base().charm_addon then
		self:_update_player_charm(t, dt, weapon:base().charm_addon)
	end
	if weapon and weapon:base() and weapon:base()._second_gun then
		self:_update_player_charm(t, dt, weapon:base()._second_gun)
	end
end)