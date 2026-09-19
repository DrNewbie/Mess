_G.JokeSteamPriceBan = _G.JokeSteamPriceBan or {}
JokeSteamPriceBan.ModPath = JokeSteamPriceBan.ModPath or ModPath
JokeSteamPriceBan.SavePath = JokeSteamPriceBan.SavePath or SavePath.."JokeSteamPriceBan.txt"
JokeSteamPriceBan.Data = JokeSteamPriceBan.Data or {low_value = 0, msg_type = 1}

function JokeSteamPriceBan:Save()
	local xfile = io.open(self.SavePath, "w+")
	if xfile then
		xfile:write(json.encode(self.Data))
		xfile:close()
	end
end

function JokeSteamPriceBan:Load()
	local xfile = io.open(self.SavePath, "r")
	if xfile then
		self.Data = json.decode(xfile:read("*all"))
		xfile:close()
	else
		self.Data = {low_value = 0, msg_type = 1}
		self:Save()
	end
	if type(self.Data.low_value) ~= "number" then
		self.Data.low_value = 0
	end
	if type(self.Data.msg_type) ~= "number" then
		self.Data.msg_type = 1
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocJokeSteamPriceBan", function(loc)
	loc:load_localization_file(JokeSteamPriceBan.ModPath.."Loc.json")
end)

Hooks:Add("MenuManagerInitialize", "MenManInitJokeSteamPriceBan", function(menu_manager)
	function MenuCallbackHandler:JokeSteamPriceBan_Callback_Save()
		JokeSteamPriceBan:Save()
	end
	function MenuCallbackHandler:JokeSteamPriceBan_low_value_clbk(item)
		JokeSteamPriceBan.Data.low_value = math.round(item:value())
	end
	function MenuCallbackHandler:JokeSteamPriceBan_msg_type_clbk(item)
		JokeSteamPriceBan.Data.msg_type = item:value()
	end
	JokeSteamPriceBan:Load()	
	MenuHelper:LoadFromJsonFile(JokeSteamPriceBan.ModPath.."Menu.json", JokeSteamPriceBan, JokeSteamPriceBan.Data)
end)