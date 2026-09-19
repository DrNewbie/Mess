_G.ee198082e5d36d96 = _G.ee198082e5d36d96 or {}
ee198082e5d36d96._path = ModPath
ee198082e5d36d96._data_path = SavePath .. "ee198082e5d36d96_options.txt"
ee198082e5d36d96.settings = {}

function ee198082e5d36d96:Save()
	local file = io.open(self._data_path, "w")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function ee198082e5d36d96:Load()
	local file = io.open(self._data_path, "r")
	if file then
		self.settings = json.decode(file:read("*all"))
		file:close()
	end
end

ee198082e5d36d96:Load()

Hooks:Add("LocalizationManagerPostInit", "F_"..Idstring("LocalizationManagerPostInit:One Down Crime Spree"):key(), function(loc )
	loc:load_localization_file(ee198082e5d36d96._path .. "loc/english.txt", false)
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_ee198082e5d36d96", function(menu_manager )
	MenuCallbackHandler.ee198082e5d36d96_toggle = function(self, item)
		ee198082e5d36d96.settings.ee198082e5d36d96_toggle_value = tostring(item:value()) == "on" and true or false
		ee198082e5d36d96:Save()
	end
	MenuCallbackHandler.ee198082e5d36d96_toggle_valueSave = function()
		ee198082e5d36d96:Save()
	end
	ee198082e5d36d96:Load()
	MenuHelper:LoadFromJsonFile(ee198082e5d36d96._path .. "menu/options.txt", ee198082e5d36d96, ee198082e5d36d96.settings )
end )


function ee198082e5d36d96:ResetToDefaultValues()
	ee198082e5d36d96.settings.ee198082e5d36d96_toggle_value = true
end

if ee198082e5d36d96.settings.ee198082e5d36d96_toggle_value == nil then
	ee198082e5d36d96:ResetToDefaultValues()
end