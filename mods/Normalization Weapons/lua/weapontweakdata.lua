Hooks:PostHook(WeaponTweakData, "_init_new_weapons", "F_"..Idstring("PostHook:WeaponTweakData:_init_new_weapons:DefaultModGun"):key(), function(self)	
	local __ge_overhaul = {
		"damage_melee",
		"damage_melee_effect_mul",
		"timers",
		"stats",
		"panic_suppression_chance",
		"autohit",
		"aim_assist",
		"shake",
		"spread",
		"auto",
		"CAN_TOGGLE_FIREMODE",
		"fire_mode_data",
		"FIRE_MODE",
		"AMMO_PICKUP",
		"AMMO_MAX",
		"NR_CLIPS_MAX",
		"CLIP_AMMO_MAX",
		"DAMAGE",
		"timers"
	}
	local __mapping = {
		["assault_rifle"] = {
			["from"] = "ak74",
			["overhaul"] = __ge_overhaul
		},
		["lmg"] = {
			["from"] = "hk21",
			["overhaul"] = __ge_overhaul
		}
	}
	
	local __old = {}	
	for _, __d in pairs(__mapping) do
		__old[__d.from] = self[__d.from]
	end
	
	for weapon_id, data in pairs(self) do
		if not data.ignore_statistics and not string.match(weapon_id, "_npc") and not string.match(weapon_id, "_crew") and data.name_id and not data.ECM_HACKABLE and not data.ACC_PITCH then
			if __mapping[self[weapon_id].categories[1]] and weapon_id ~= __mapping[self[weapon_id].categories[1]].from then
				for _, __d in pairs(__mapping[self[weapon_id].categories[1]].overhaul) do
					if self[weapon_id] and weapon_id and __d then
						self[weapon_id][__d] = __old[__mapping[self[weapon_id].categories[1]].from][__d]
					end
				end
			end
		end
	end
end)