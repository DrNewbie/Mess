local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_MoreWeaponStats', function(loc)
	local language_filename

	if BLT.Localization._current == 'cht' or BLT.Localization._current == 'zh-cn' then
		language_filename = 'chinese.txt'
	end

	if not language_filename then
		local modname_to_language = {
			['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
		}
		for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
			language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
			if language_filename then
				break
			end
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(MoreWeaponStats._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(MoreWeaponStats._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(MoreWeaponStats._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_MoreWeaponStats', function(menu_manager)

	MenuCallbackHandler.MoreWeaponStatsMenuCheckboxClbk = function(this, item)
		MoreWeaponStats.settings[item:name()] = item:value() == 'on'
	end

	MenuCallbackHandler.MoreWeaponStatsMenuValueClbk = function(this, item)
		MoreWeaponStats.settings[item:name()] = math.floor(item:value())
	end

	MenuCallbackHandler.MoreWeaponStatsSave = function(this, item)
		MoreWeaponStats:Save()
	end

	MoreWeaponStats:Load()

	MenuHelper:LoadFromJsonFile(MoreWeaponStats._path .. 'menu/options.txt', MoreWeaponStats, MoreWeaponStats.settings)

end)
