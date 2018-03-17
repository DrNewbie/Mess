local CopRandomWeapon = CopMovement.add_weapons

function CopMovement:add_weapons(...)
	local _default_weapon_id = self._ext_base._default_weapon_id or "m4"
	if self._unit and alive(self._unit) and self._unit:in_slot(managers.slot:get_mask("enemies")) and managers.weapon_factory and self._unit:inventory() and self._unit:inventory().add_unit_by_factory_name and not self._unit:inventory()._shield_unit_name and _default_weapon_id then
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
				--[[
				if RndCopWeapGKey and RndCopWeapGKey.Options and RndCopWeapGKey.Options:GetValue("EnableSkins") then
					if math.random() < RndCopWeapGKey.Options:GetValue("SkinsRate") then
						cosmetics_str = table.random_key(tweak_data.blackmarket.weapon_skins) .. "-" .. table.random_key(tweak_data.economy.qualities) .. "-0"
					end
				end
				]]
				self._unit:inventory():add_unit_by_factory_name(weapon, true, true, nil, cosmetics_str)
			else
				if prim_weap_name then
					self._unit:inventory():add_unit_by_name(prim_weap_name)
				end
				if sec_weap_name and sec_weap_name ~= prim_weap_name then
					self._unit:inventory():add_unit_by_name(sec_weap_name)
				end
			end
			if self._unit:inventory():equipped_unit() and self._unit:inventory():equipped_unit():base() then
				self._unit:inventory():equipped_unit():base()._hit_player = true
				self._unit:inventory():equipped_unit():base():weapon_tweak_data().usage = usage
			end
			return
		end
	end
	CopRandomWeapon(self, ...)
end