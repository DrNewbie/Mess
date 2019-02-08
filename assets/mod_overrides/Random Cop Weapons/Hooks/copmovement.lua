local CopRandomWeapon = CopMovement.add_weapons

function CopMovement:add_weapons(...)
	local _default_weapon_id = self._ext_base._default_weapon_id or "m4"
	local _use_defualt_weapon = false
	if RndCopWeapGKey and RndCopWeapGKey.Options and RndCopWeapGKey.Options:GetValue("EnableDefaultWep") then
		if RndCopWeapGKey.Options:GetValue("DefaultWepRate") < math.random() then
			_use_defualt_weapon = false
		else
			_use_defualt_weapon = true
		end
	end
	if not _use_defualt_weapon and self._unit and alive(self._unit) and self._unit:in_slot(managers.slot:get_mask("enemies")) and managers.weapon_factory and self._unit:inventory() and self._unit:inventory().add_unit_by_factory_name and not self._unit:inventory()._shield_unit_name and _default_weapon_id then
		local usage = nil
		local crew_wep = _default_weapon_id.."_crew"
		if tweak_data.weapon[crew_wep] and tweak_data.weapon[crew_wep].usage then
			usage = tweak_data.weapon[crew_wep].usage
		end
		local npc_wep = _default_weapon_id.."_npc"
		if tweak_data.weapon[npc_wep] and tweak_data.weapon[npc_wep].usage then
			usage = tweak_data.weapon[npc_wep].usage
		end
		local RandomWeaponMap = managers.weapon_factory:GetFromRandomWeaponMap(usage) or {}
		local prim_weap_name = self._ext_base:default_weapon_name("primary")
		local sec_weap_name = self._ext_base:default_weapon_name("secondary")
		if RandomWeaponMap and table.size(RandomWeaponMap) > 0 then
			local weapon = table.random(RandomWeaponMap)
			if weapon and (prim_weap_name or sec_weap_name) then
				local cosmetics_str = ""
				local blueprint_string, blueprint = nil, {}
				if RndCopWeapGKey and RndCopWeapGKey.Options then
					if RndCopWeapGKey.Options:GetValue("EnableSkins") then
						if math.random() < RndCopWeapGKey.Options:GetValue("SkinsRate") then
							local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(weapon:gsub("_npc", ""))
							if weapon_id then
								local skins_key = managers.blackmarket:get_weapon_skins(weapon_id)
								if type(skins_key) == "table" and table.size(skins_key) > 0 then
									cosmetics_str = table.random_key(skins_key) .. "-" .. table.random_key(tweak_data.economy.qualities) .. "-0"
								end
							end
						end
					end
					if RndCopWeapGKey.Options:GetValue("EnableWepMods") then
						local factory_data = tweak_data.weapon.factory[weapon]
						if math.random() < RndCopWeapGKey.Options:GetValue("WepModsRate") and type(factory_data) == "table" and type(factory_data.uses_parts) == "table" then
							local mods_type = {}
							for i, d in pairs(factory_data.uses_parts) do 
								if tweak_data.weapon.factory.parts[d] then
									local mod_type = tostring(tweak_data.weapon.factory.parts[d].type)
									mods_type[mod_type] = mods_type[mod_type] or {}
									table.insert(mods_type[mod_type], d)
								end
							end
							for i, d in pairs(mods_type) do 
								table.insert(blueprint, table.random(d))
							end
							blueprint_string = managers.weapon_factory:blueprint_to_string(weapon:gsub("_npc", ""), blueprint)
						end
					end
				end
				self._unit:inventory():add_unit_by_factory_name(weapon, true, true, blueprint_string, cosmetics_str)
			else
				if prim_weap_name then
					self._unit:inventory():add_unit_by_name(prim_weap_name)
				end
				if sec_weap_name and sec_weap_name ~= prim_weap_name then
					self._unit:inventory():add_unit_by_name(sec_weap_name)
				end
			end
			local weapon_base = self._unit:inventory():equipped_unit() and self._unit:inventory():equipped_unit():base() or nil
			if weapon_base and alive(weapon_base._unit) then
				weapon_base._hit_player = true
				weapon_base:weapon_tweak_data().usage = usage
				if RndCopWeapGKey and RndCopWeapGKey.Options and RndCopWeapGKey.Options:GetValue("EnableWepGadget") then
					if math.random() < RndCopWeapGKey.Options:GetValue("WepGadgetRate") and weapon_base._parts then
						local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", weapon_base._parts)
						if gadget and gadget.unit and alive(gadget.unit) then
							local part_base = gadget.unit and gadget.unit:base()
							if part_base and type(part_base.GADGET_TYPE) == "string" and part_base.set_color and part_base.set_state then
								local colors = {
									laser = Color.red,
									flashlight = tweak_data.custom_colors.defaults.flashlight
								}
								if colors[part_base.GADGET_TYPE] then
									part_base:set_color(colors[part_base.GADGET_TYPE]:with_alpha(part_base.GADGET_TYPE == "laser" and 1 or tweak_data.custom_colors.defaults.laser_alpha))
									part_base:set_state(true)
								end
							end
						end
					end
				end
			end
			return
		end
	end
	CopRandomWeapon(self, ...)
end