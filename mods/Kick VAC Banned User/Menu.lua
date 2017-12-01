if ModCore then
	ModCore:new(ModPath.."Updater.xml", false, true):init_modules()
end

_G.JokeVACBan = _G.JokeVACBan or {}

JokeVACBan.ModPath = JokeVACBan.ModPath or ModPath

JokeVACBan.SavePath = JokeVACBan.SavePath or SavePath.."JokeVACBan.txt"

JokeVACBan.Data = JokeVACBan.Data or {days_max = 5}

function JokeVACBan:Save()
	local file = io.open(self.SavePath, "w+")
	if file then
		file:write(json.encode(self.Data))
		file:close()
	end
end

function JokeVACBan:Load()
	local file = io.open(self.SavePath, "r")
	if file then
		self.Data = json.decode(file:read("*all"))
		file:close()
	else
		JokeVACBan.Data = {days_max = 5}
		self:Save()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocJokeVACBan", function(loc)
	loc:load_localization_file(JokeVACBan.ModPath.."Loc.json")
end)

Hooks:Add("MenuManagerInitialize", "MenManInitJokeVACBan", function(menu_manager)
	function MenuCallbackHandler:JokeVACBan_Callback_Save()
		JokeVACBan:Save()
	end	
	function MenuCallbackHandler:JokeVACBan_days_max(item)
		JokeVACBan.Data.days_max = item:value()
	end	
	JokeVACBan:Load()	
	MenuHelper:LoadFromJsonFile(JokeVACBan.ModPath.."Menu.json", JokeVACBan, JokeVACBan.Data)
end)