local AkimboWTF_get_stats = WeaponDescription._get_stats

function WeaponDescription._get_stats(name, category, slot, blueprint)
	local base_stats, mods_stats, skill_stats = AkimboWTF_get_stats(name, base_stats, equipped_mods, bonus_stats)
	
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local blueprint = blueprint or slot and managers.blackmarket:get_weapon_blueprint(category, slot) or managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	
	local tweak_factory = tweak_data.weapon.factory.parts
	
	if blueprint then
		for _, f_id in pairs(blueprint) do
			if type(tweak_factory[f_id].stats) == "table" and tweak_factory[f_id].stats.akimbo_wtf_buff then
				local akimbo_wtf_buff = tweak_factory[f_id].stats.akimbo_wtf_buff
				base_stats.totalammo.value = base_stats.totalammo.value <= 0 and 1 or base_stats.totalammo.value
				base_stats.totalammo.value = base_stats.totalammo.value * akimbo_wtf_buff
				base_stats.magazine.value = base_stats.magazine.value <= 0 and 1 or base_stats.magazine.value
				base_stats.magazine.value = base_stats.magazine.value * akimbo_wtf_buff
			end
		end
	end
	
	return base_stats, mods_stats, skill_stats
end