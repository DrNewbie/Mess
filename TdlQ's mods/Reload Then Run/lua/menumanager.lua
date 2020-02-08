_G.ReloadThenRun = _G.ReloadThenRun or {}
ReloadThenRun._path = ModPath
ReloadThenRun._data_path = SavePath .. 'reload_then_run.txt'
ReloadThenRun.settings = {
	block_after_pct = 0.85,
}

function ReloadThenRun:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all'))) do
			self.settings[k] = v
		end
		file:close()
	end
end

function ReloadThenRun:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_ReloadThenRun', function(loc)
	local language_filename

	local modname_to_language = {
		['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
	}
	for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
		language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
		if language_filename then
			break
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(ReloadThenRun._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(ReloadThenRun._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(ReloadThenRun._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_ReloadThenRun', function(menu_manager)
	MenuCallbackHandler.ReloadThenRunBlockAfter = function(self, item)
		ReloadThenRun.settings.block_after_pct = tonumber(item:value())
	end

	MenuCallbackHandler.ReloadThenRunSave = function(this, item)
		ReloadThenRun:Save()
	end

	ReloadThenRun:Load()
	MenuHelper:LoadFromJsonFile(ReloadThenRun._path .. 'menu/options.txt', ReloadThenRun, ReloadThenRun.settings)
end)

