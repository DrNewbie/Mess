Hooks:PostHook(PlayerDamage, "init", Idstring("overkill_damage_multiplier_gun_effect_init"):key(), function(self)
	if managers.player:has_category_upgrade("temporary", "overkill_damage_multiplier") then
		self._ovk_dmg_muti_gun_eff_list = {}
	end
end)

Hooks:PostHook(PlayerDamage, "update", Idstring("overkill_damage_multiplier_gun_effect_update"):key(), function(self, unit, t, dt)
	local weapon_unit = managers.player:equipped_weapon_unit()
	if not weapon_unit then
		return
	end
	if managers.player:has_activate_temporary_upgrade("temporary", "overkill_damage_multiplier") then
		
		if not self._ovk_dmg_muti_gun_eff_list[1] then
			local blueprint = weapon_unit:base()._blueprint
			if blueprint then
				local obj = {}
				for _, wd in pairs(blueprint) do
					if tweak_data.weapon.factory.parts[wd] then
						table.insert(obj, tweak_data.weapon.factory.parts[wd].a_obj)
					end
				end
				local aobjs = {}
				for i = 1, 3 do
					local key = table.random_key(obj)
					if obj[key] then
						table.insert(aobjs, obj[key])
						obj[key] = nil
					end
				end
				for _, aobj in pairs(aobjs) do
					table.insert(self._ovk_dmg_muti_gun_eff_list, World:effect_manager():spawn({
						effect = Idstring("effects/payday2/particles/character/taser_thread"),
						parent = weapon_unit:get_object(Idstring(aobj))
					}))
				end
				self._ovk_dmg_muti_gun_eff_remove = true
				local data = managers.player:upgrade_value("temporary", "overkill_damage_multiplier", {})
				self._ovk_dmg_muti_gun_eff_delay = data[2] or 0.1
				math.randomseed(Idstring(tostring(os.time())):key())
				self._ovk_dmg_muti_gun_eff_aobjs = aobjs
				self._ovk_dmg_muti_gun_eff_reboot = nil
				return
			end
		end
	end
	if self._ovk_dmg_muti_gun_eff_delay then
		self._ovk_dmg_muti_gun_eff_delay = self._ovk_dmg_muti_gun_eff_delay - dt
		if self._ovk_dmg_muti_gun_eff_delay <= 0 then
			self._ovk_dmg_muti_gun_eff_delay = nil
			self._ovk_dmg_muti_gun_eff_reboot = nil
		else
			if math.round(self._ovk_dmg_muti_gun_eff_delay) % 5 == 0 then
				if not self._ovk_dmg_muti_gun_eff_reboot then
					self._ovk_dmg_muti_gun_eff_reboot = true
					for _, aobj in pairs(self._ovk_dmg_muti_gun_eff_aobjs) do
						table.insert(self._ovk_dmg_muti_gun_eff_list, World:effect_manager():spawn({
							effect = Idstring("effects/payday2/particles/character/taser_thread"),
							parent = weapon_unit:get_object(Idstring(aobj))
						}))
					end
				end
			elseif math.round(self._ovk_dmg_muti_gun_eff_delay) % 5 == 4 then
				self._ovk_dmg_muti_gun_eff_reboot = nil
			end
		end
	else
		if self._ovk_dmg_muti_gun_eff_remove then
			self._ovk_dmg_muti_gun_eff_remove = false
			for k, v in pairs(self._ovk_dmg_muti_gun_eff_list) do
				World:effect_manager():fade_kill(v)
				self._ovk_dmg_muti_gun_eff_list[k] = nil
			end
		end
	end
end)