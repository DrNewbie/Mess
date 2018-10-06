_G.JokeSteamLevelsBan = _G.JokeSteamLevelsBan or {}

JokeSteamLevelsBan.ModPath = JokeSteamLevelsBan.ModPath or ModPath

JokeSteamLevelsBan.SavePath = JokeSteamLevelsBan.SavePath or SavePath.."JokeSteamLevelsBan.txt"

JokeSteamLevelsBan.Data = JokeSteamLevelsBan.Data or {low_leves = 0}

function JokeSteamLevelsBan:Save()
	local xfile = io.open(self.SavePath, "w+")
	if xfile then
		xfile:write(json.encode(self.Data))
		xfile:close()
	end
end

function JokeSteamLevelsBan:Load()
	local xfile = io.open(self.SavePath, "r")
	if xfile then
		self.Data = json.decode(xfile:read("*all"))
		xfile:close()
	else
		JokeSteamLevelsBan.Data = {low_leves = 0}
		self:Save()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocJokeSteamLevelsBan", function(loc)
	loc:load_localization_file(JokeSteamLevelsBan.ModPath.."Loc.json")
end)

Hooks:Add("MenuManagerInitialize", "MenManInitJokeSteamLevelsBan", function(menu_manager)
	function MenuCallbackHandler:JokeSteamLevelsBan_Callback_Save()
		JokeSteamLevelsBan:Save()
	end	
	function MenuCallbackHandler:JokeSteamLevelsBan_low_leves(item)
		JokeSteamLevelsBan.Data.low_leves = math.round(item:value())
	end	
	JokeSteamLevelsBan:Load()	
	MenuHelper:LoadFromJsonFile(JokeSteamLevelsBan.ModPath.."Menu.json", JokeSteamLevelsBan, JokeSteamLevelsBan.Data)
end)