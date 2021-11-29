local old_func = WeaponFactoryManager.verify_weapon
local check_ans = {}

function WeaponFactoryManager:verify_weapon(weapon_id, factory_id, ...)
	if not weapon_id or not factory_id then
		return true
	end
	if check_ans[weapon_id] and check_ans[weapon_id][factory_id] then
		return check_ans[weapon_id][factory_id]
	end
	check_ans[weapon_id] = check_ans[weapon_id] or {}
	check_ans[weapon_id][factory_id] = old_func(self, weapon_id, factory_id, ...)
	return check_ans[weapon_id][factory_id]
end