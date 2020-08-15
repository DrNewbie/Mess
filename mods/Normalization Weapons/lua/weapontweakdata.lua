Hooks:PostHook(WeaponTweakData, "_init_new_weapons", "F_"..Idstring("PostHook:WeaponTweakData:_init_new_weapons:DefaultModGun"):key(), function(self)	
	local __ak47 = self.ak74
	for weapon_id, data in pairs(self) do
		if not data.ignore_statistics and not string.match(weapon_id, "_npc") and not string.match(weapon_id, "_crew") and data.name_id and not data.ECM_HACKABLE and not data.ACC_PITCH then
			if self[weapon_id].categories[1] == "assault_rifle" and weapon_id ~= "ak74" then 
				self[weapon_id].damage_melee = __ak47.damage_melee
				self[weapon_id].damage_melee_effect_mul = __ak47.damage_melee_effect_mul
				self[weapon_id].timers = __ak47.timers
				self[weapon_id].stats = __ak47.stats
				self[weapon_id].panic_suppression_chance = __ak47.panic_suppression_chance
				self[weapon_id].panic_suppression_chance = __ak47.panic_suppression_chance
				self[weapon_id].autohit = __ak47.autohit
				self[weapon_id].aim_assist = __ak47.aim_assist
				self[weapon_id].shake = __ak47.shake
				self[weapon_id].spread = __ak47.spread
				self[weapon_id].auto = __ak47.auto
				self[weapon_id].CAN_TOGGLE_FIREMODE = __ak47.CAN_TOGGLE_FIREMODE
				self[weapon_id].fire_mode_data = __ak47.fire_mode_data
				self[weapon_id].FIRE_MODE = __ak47.FIRE_MODE
				self[weapon_id].AMMO_PICKUP = __ak47.AMMO_PICKUP
				self[weapon_id].AMMO_MAX = __ak47.AMMO_MAX
				self[weapon_id].NR_CLIPS_MAX = __ak47.NR_CLIPS_MAX
				self[weapon_id].CLIP_AMMO_MAX = __ak47.CLIP_AMMO_MAX
				self[weapon_id].DAMAGE = __ak47.DAMAGE
				self[weapon_id].timers = __ak47.timers
			end
		end
	end
end)