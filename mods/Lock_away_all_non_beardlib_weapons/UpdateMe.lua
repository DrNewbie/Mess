local ModPath = ModPath

local function Update_UnlockCustomWeapon(ModPath)
	local _file = io.open(ModPath .. 'weapontweakdata.lua', "w")
	if not _file then
		return
	end
	_file:write('--??')
	_file:close()
	_file = io.open(ModPath .. 'weapontweakdata.lua', "w")
	if not managers.weapon_factory or not tweak_data.statistics then
		return
	end
	local _, _, _, _weapon_lists, _, _, _, _, _ = tweak_data.statistics:statistics_table()
	if not _weapon_lists then
		return
	end
	_file:write('Hooks:PostHook(WeaponTweakData, "init", "UnlockCustomWeapon", function(self, ...) \n')
	for _, _weapon_id in pairs(_weapon_lists) do
		local _wd = tweak_data.weapon[_weapon_id] or nil
		if _wd then
			_file:write('	self["'.. _weapon_id ..'"].global_value = "nonbeardlib" \n')
		end
	end
	_file:write('end) \n')
	_file:close()
	return true
end

Hooks:Add('MenuManagerOnOpenMenu', 'UnlockCustomWeapon_RunInitNow', function(self, menu, ...)
	if menu == 'menu_main' then
		--Update_UnlockCustomWeapon(ModPath)
	end
end)

Hooks:Add("LocalizationManagerPostInit", "UnlockCustomWeapon_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["bm_global_value_nonbeardlib"] = "bm_global_value_nonbeardlib",
		["menu_content_nonbeardlib_desc"] = "menu_content_nonbeardlib_desc",
		["menu_l_global_value_nonbeardlib"] = "This weapon is non-beardlib weapon",
		["bm_global_value_nonbeardlib_unlock"] = "Non-beardlib weapon is blocked by Mod"
	})
end)