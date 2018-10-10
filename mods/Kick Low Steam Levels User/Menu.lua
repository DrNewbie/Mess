_G.JokeSteamLevelsBan = _G.JokeSteamLevelsBan or {}

JokeSteamLevelsBan.ModPath = JokeSteamLevelsBan.ModPath or ModPath

JokeSteamLevelsBan.SavePath = JokeSteamLevelsBan.SavePath or SavePath.."JokeSteamLevelsBan.txt"

JokeSteamLevelsBan.Data = JokeSteamLevelsBan.Data or {low_leves = 0, kick_type = 1, msg_type = 1}

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
		self.Data = {low_leves = 0, kick_type = 1, msg_type = 1}
		self:Save()
	end
	if type(self.Data.low_leves) ~= "number" then
		self.Data.low_leves = 0
	end
	if type(self.Data.kick_type) ~= "number" then
		self.Data.low_leves = 1
	end
	if type(self.Data.msg_type) ~= "number" then
		self.Data.msg_type = 1
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocJokeSteamLevelsBan", function(loc)
	loc:load_localization_file(JokeSteamLevelsBan.ModPath.."Loc.json")
end)

Hooks:Add("MenuManagerInitialize", "MenManInitJokeSteamLevelsBan", function(menu_manager)
	function MenuCallbackHandler:JokeSteamLevelsBan_Callback_Save()
		JokeSteamLevelsBan:Save()
	end
	function MenuCallbackHandler:JokeSteamLevelsBan_low_leves_clbk(item)
		JokeSteamLevelsBan.Data.low_leves = math.round(item:value())
	end
	function MenuCallbackHandler:JokeSteamLevelsBan_kick_type_clbk(item)
		JokeSteamLevelsBan.Data.kick_type = item:value()
	end
	function MenuCallbackHandler:JokeSteamLevelsBan_msg_type_clbk(item)
		JokeSteamLevelsBan.Data.msg_type = item:value()
	end
	JokeSteamLevelsBan:Load()	
	MenuHelper:LoadFromJsonFile(JokeSteamLevelsBan.ModPath.."Menu.json", JokeSteamLevelsBan, JokeSteamLevelsBan.Data)
end)