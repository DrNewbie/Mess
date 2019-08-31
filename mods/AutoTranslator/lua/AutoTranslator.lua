_G.AutoTranslator = _G.AutoTranslator or {}

AutoTranslator.options_menu = "AutoTranslator_menu"
AutoTranslator.ModPath = ModPath
AutoTranslator.SaveFile = AutoTranslator.SaveFile or SavePath .. "AutoTranslator.txt"
AutoTranslator.settings = AutoTranslator.settings or {}
AutoTranslator._SL = "auto"
AutoTranslator.no_translate = {}
AutoTranslator.Block = {}

function AutoTranslator:Do_Init()
	local _file = io.open(self.ModPath .. "list_of_no_translate.txt", "r")
	if _file then
		self.no_translate = json.decode(_file:read("*all" ))
		_file:close()
		_file = nil
	end
	_file = io.open(self.ModPath .. "list_of_possible.txt", "r")
	self.list_of_possible = {}
	self.list_of_possible_item = {}
	if _file then
		self.list_of_possible = json.decode(_file:read("*all" ))
		_file:close()
		_file = nil
	end
end

function AutoTranslator:displayMessage(channel_id, name, msg, color, icon)
	local receivers = managers.chat._receivers[channel_id]
	if not receivers then
		return
	end
	call_on_next_update(function ()
		managers.chat:_receive_message(channel_id, name, msg, color, icon)
	end)
end

function AutoTranslator:lookupTranslation(channel_id, name, msg, color, icon)
	local _nowtime = math.round(Application:time())
	local _tl = "en"
	local _select = tonumber(self.settings.Language) or 1
	local _list = self.list_of_possible or {}
	if _list and _list[_select] and _list[_select][1] then
		_tl = _list[_select][1]
	end
	local url_encode = function (str)
		if (str) then
			str = string.gsub (str, "\n", "\r\n")
			str = string.gsub (str, "([^%w %-%_%.%~])",
				function (c) return string.format ("%%%02X", string.byte(c)) end)
			str = string.gsub (str, " ", "+")
		end
		return str
	end
	local msg_key = tostring(Idstring(msg):key())
	self.Block = self.Block or {}
	if self.Block[msg_key] and type(self.Block[msg_key]) == "number" and self.Block[msg_key] then
		if self.Block[msg_key] + 5 > _nowtime then
			return
		end
		self.Block[msg_key] = 0
		self.Block[msg_key] = nil
	end
	for id, data in pairs(self.Block) do
		if self.Block[id] and type(self.Block[id]) == "number" and self.Block[id] + 5 < _nowtime then
			self.Block[id] = 0
			self.Block[id] = nil
		end	
	end
	self.Block[msg_key] = _nowtime
	msg = url_encode(msg)
	dohttpreq("https://translate.googleapis.com/translate_a/single?client=gtx&ie=utf-8&sl=".. self._SL .."&tl=".. _tl .."&dt=t&text=" .. msg, function(data)
		if data and json then
			data = data:gsub(",,", ",")
			data = data:gsub(",,", ",")
			data = json.decode(data) or {}
			if data[1] and data[1][1] and data[1][1][1] and data[2] and data[2] ~= _tl and not self.no_translate[data[2]] then
				local _message2send = tostring(" " .. data[1][1][1] .. " ")
				self.Block[Idstring(_message2send):key()] = _nowtime
				self:displayMessage(channel_id, name, _message2send, color, icon)
			end
		end
	end)
end

function AutoTranslator:Reset()
	self.settings = {
		Language = 1,
	}
	self:Save()
end

function AutoTranslator:Load()
	local file = io.open(self.SaveFile, "r")
	if file then
		for key, value in pairs(json.decode(file:read("*all"))) do
			self.settings[key] = value
		end
		file:close()
	else
		self:Reset()
	end
end

function AutoTranslator:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

AutoTranslator:Do_Init()

AutoTranslator:Load()

Hooks:Add("ChatManagerOnReceiveMessage", "AutoTranslator_ChatManagerOnReceiveMessage",
	function(channel_id, name, message, color, icon)
		AutoTranslator:lookupTranslation(channel_id, name.." [AT]", message, color, icon)
	end
)

Hooks:Add("LocalizationManagerPostInit", "AutoTranslator_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["AutoTranslator_menu_title"] = "Auto-Translator",
		["AutoTranslator_menu_desc"] = "",
		["AutoTranslator_menu_Language_title"] = "Language",
		["AutoTranslator_menu_Language_desc"] = "",
	})
	local i = 1
	for lng, clng in pairs(AutoTranslator.list_of_possible) do
		AutoTranslator.list_of_possible_item[i] = "AutoTranslator_possible_".. lng .."_title"
		LocalizationManager:add_localized_strings({[AutoTranslator.list_of_possible_item[i]] = clng})
		i = i + 1
	end
end)

Hooks:Add("MenuManagerSetupCustomMenus", "AutoTranslatorOptions_NewMenu", function( menu_manager, nodes )
	MenuHelper:NewMenu( AutoTranslator.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "AutoTranslatorOptions_AddMultipleChoice", function( menu_manager, nodes )
	MenuCallbackHandler.AutoTranslator_menu_Language_callback = function(self, item)
		AutoTranslator.settings.Language = tostring(item:value())
		AutoTranslator:Save()
	end
	MenuHelper:AddMultipleChoice({
		id = "AutoTranslator_menu_Language_callback",
		title = "AutoTranslator_menu_Language_title",
		desc = "AutoTranslator_menu_Language_desc",
		callback = "AutoTranslator_menu_Language_callback",
		items = AutoTranslator.list_of_possible_item,
		menu_id = AutoTranslator.options_menu,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "AutoTranslatorOptions_AddMenuItem", function(menu_manager, nodes)
	nodes[AutoTranslator.options_menu] = MenuHelper:BuildMenu( AutoTranslator.options_menu )
	MenuHelper:AddMenuItem(nodes["blt_options"], AutoTranslator.options_menu, "AutoTranslator_menu_title", "AutoTranslator_menu_desc")
end)