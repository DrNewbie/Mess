local ThisModPath = ModPath

local __Name = function(__id)
	return "NW_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")

if WeaponTweakData and not WeaponTweakData[is_bool] then
	WeaponTweakData[is_bool] = true

	Hooks:PostHook(WeaponTweakData, "_init_new_weapons", __Name("1"), function(self, ...)
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
		
		local __get_cat_ids = function (__cat)
			return __Name(tostring(json.encode(__cat)))
		end
		
		local ids_assault_rifle = __get_cat_ids(self.ak74.categories)
		local ids_lmg = __get_cat_ids(self.hk21.categories)
		local __mapping = {
			[ids_assault_rifle] = {
				["from"] = "ak74",
				["overhaul"] = __ge_overhaul
			},
			[ids_lmg] = {
				["from"] = "hk21",
				["overhaul"] = __ge_overhaul
			}
		}
		
		for weapon_id, data in pairs(self) do
			if not data.ignore_statistics and not string.match(weapon_id, "_npc") and not string.match(weapon_id, "_crew") and data.name_id and not data.ECM_HACKABLE and not data.ACC_PITCH then
				local __cat_ids = __get_cat_ids(data.categories)
				if not __mapping[__cat_ids] then				
					__mapping[__cat_ids] = {
						["from"] = weapon_id,
						["overhaul"] = __ge_overhaul				
					}
				end
			end
		end
		
		local __old = {}
		for _, __d in pairs(__mapping) do
			__old[__d.from] = self[__d.from]
		end
		
		for weapon_id, data in pairs(self) do
			if not data.ignore_statistics and not string.match(weapon_id, "_npc") and not string.match(weapon_id, "_crew") and data.name_id and not data.ECM_HACKABLE and not data.ACC_PITCH then
				local __cat_ids = __get_cat_ids(data.categories)
				if __mapping[__cat_ids] and __mapping[__cat_ids].overhaul and weapon_id ~= __mapping[__cat_ids].from then
					for _, __d in pairs(__mapping[__cat_ids].overhaul) do
						if self[weapon_id] and weapon_id and __d then
							self[weapon_id][__d] = __old[__mapping[__cat_ids].from][__d]
						end
					end
				end
			end
		end
	end)
end

if WeaponFactoryTweakData and not WeaponFactoryTweakData[is_bool] then
	WeaponFactoryTweakData[is_bool] = true

	Hooks:PostHook(WeaponFactoryTweakData, "init", __Name("2"), function(self, ...)
		for part_id, part_data in pairs(self.parts) do
			self.parts[part_id].stats = {}
			self.parts[part_id].adds = {}
			self.parts[part_id].stance_mod = {}
			self.parts[part_id].perks = {}
			self.parts[part_id].override = {}
			self.parts[part_id].custom_stats = {}
			self.parts[part_id].forbids = {}
		end
	end)

	Hooks:PostHook(WeaponFactoryTweakData, "create_bonuses", __Name("3"), function(self, ...)
		for part_id, part_data in pairs(self.parts) do
			self.parts[part_id].stats = {}
			self.parts[part_id].adds = {}
			self.parts[part_id].stance_mod = {}
			self.parts[part_id].perks = {}
			self.parts[part_id].override = {}
			self.parts[part_id].custom_stats = {}
			self.parts[part_id].forbids = {}
		end
	end)
end