_G.CustomDotSize = _G.CustomDotSize or {}
CustomDotSize.ModPath = ModPath
CustomDotSize.SaveFile = CustomDotSize.SaveFile or SavePath .. "CustomDotSize.txt"
CustomDotSize.ModOptions = CustomDotSize.ModPath .. "menus/modoptions.txt"
CustomDotSize.Settings = {}

function CustomDotSize:Reset()
	self.Settings = {
		dot_px = 5.0
	}
	self:Save()
end

function CustomDotSize:Load()
	local file = io.open(self.SaveFile, "r")
	if file then
		for key, value in pairs(json.decode(file:read("*all"))) do
			self.Settings[key] = value
		end
		file:close()
	else
		self:Reset()
	end
end

function CustomDotSize:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.Settings))
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CustomDotSize", function(loc)
	loc:load_localization_file(CustomDotSize.ModPath .. "loc/english.txt", false)
end)


CustomDotSize:Load()