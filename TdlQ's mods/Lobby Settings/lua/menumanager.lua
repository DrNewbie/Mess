local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.LobbySettings = _G.LobbySettings or {}
LobbySettings._path = ModPath
LobbySettings._data_path = SavePath .. 'lobby_settings.txt'
LobbySettings.friends = {}
LobbySettings.settings = {
	reject_vac = false,
	reject_play_time_threshold = 0,
	reject_unknown_play_time = false,
}

function LobbySettings:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		local settings = self.settings
		settings.lobby_permission = Global.game_settings.permission
		settings.reputation_permission = Global.game_settings.reputation_permission
		settings.infamy_permission = Global.game_settings.infamy_permission
		settings.max_players = Global.game_settings.max_players
		settings.max_bots = Global.game_settings.max_bots

		file:write(json.encode(settings))
		file:close()
	end
end

function LobbySettings:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
	Global.game_settings.permission = self.settings.lobby_permission or 'friends_only'
	Global.game_settings.infamy_permission = self.settings.infamy_permission or 0
	Global.game_settings.reputation_permission = self.settings.reputation_permission or 0
	Global.game_settings.max_players = self.settings.max_players or tweak_data.max_players
	Global.game_settings.max_bots = self.settings.max_bots or CriminalsManager.MAX_NR_TEAM_AI
end

function LobbySettings:ResetStatus(include_banned)
	local ls_status = Global.ls_status
	if type(ls_status) ~= 'table' then
		return
	end

	for steam_id, status in pairs(ls_status) do
		if status == true or type(status) == 'number' and (include_banned or status ~= 9) then
			ls_status[steam_id] = nil
		end
	end
end

function LobbySettings:InitFriendsList()
	self.friends = {}
	if Steam and Steam:logged_on() then
		for _, friend in ipairs(Steam:friends() or {}) do
			self.friends[friend:id()] = true
		end
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_LobbySettings', function(loc)
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
		for _, filename in pairs(file.GetFiles(LobbySettings._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(LobbySettings._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(LobbySettings._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_LobbySettings', function(menu_manager)

	LobbySettings:InitFriendsList()
	LobbySettings:Load()

	local funcs = {
		'choice_crimenet_lobby_permission',
		'choice_lobby_permission',
		'choice_lobby_reputation_permission',
	}
	for _, func in pairs(funcs) do
		local original_function = MenuCallbackHandler[func]
		MenuCallbackHandler[func] = function(...)
			original_function(...)
			LobbySettings:Save()
		end
	end

	function MenuCallbackHandler:ls_choice_lobby_infamy_permission(item)
		local infamy_permission = item:value()
		Global.game_settings.infamy_permission = infamy_permission
		if LobbySettings.egs_item_infamy and item ~= LobbySettings.egs_item_infamy then
			LobbySettings.egs_item_infamy:set_value(infamy_permission)
		end
		LobbySettings:Save()
	end

	function MenuCallbackHandler:ls_choice_lobby_max_players(item)
		local max_players = item:value()
		Global.game_settings.max_players = max_players
		if LobbySettings.egs_item_max_players and item ~= LobbySettings.egs_item_max_players then
			LobbySettings.egs_item_max_players:set_value(max_players)
		end
		if Network:is_server() then
			managers.network:session():chk_server_joinable_state()
		end
		LobbySettings:Save()
	end

	function MenuCallbackHandler:ls_choice_lobby_max_bots(item)
		local max_bots = item:value()
		Global.game_settings.team_ai = max_bots > 0
		Global.game_settings.team_ai_option = max_bots
		Global.game_settings.max_bots = max_bots
		if LobbySettings.egs_item_max_bots and item ~= LobbySettings.egs_item_max_bots then
			LobbySettings.egs_item_max_bots:set_value(max_bots)
		end
		LobbySettings:Save()
	end

	function MenuCallbackHandler:ls_choice_lobby_reject_vac(item)
		local reject_vac = item:value() == 'on'
		LobbySettings.settings.reject_vac = reject_vac
		if LobbySettings.egs_item_reject_vac and item ~= LobbySettings.egs_item_reject_vac then
			LobbySettings.egs_item_reject_vac:set_value(reject_vac and 'on' or 'off')
		end
		LobbySettings:ResetStatus(true)
		LobbySettings:Save()
	end

	function MenuCallbackHandler:ls_choice_lobby_reject_play_time_threshold(item)
		local reject_play_time_threshold = item:value()
		LobbySettings.settings.reject_play_time_threshold = reject_play_time_threshold
		if LobbySettings.egs_item_reject_play_time_threshold and item ~= LobbySettings.egs_item_reject_play_time_threshold then
			LobbySettings.egs_item_reject_play_time_threshold:set_value(reject_play_time_threshold)
		end
		LobbySettings:ResetStatus()
		LobbySettings:Save()
	end

	function MenuCallbackHandler:ls_choice_lobby_reject_unknown_play_time(item)
		local reject_unknown_play_time = item:value() == 'on'
		LobbySettings.settings.reject_unknown_play_time = reject_unknown_play_time
		if LobbySettings.egs_item_reject_unknown_play_time and item ~= LobbySettings.egs_item_reject_unknown_play_time then
			LobbySettings.egs_item_reject_unknown_play_time:set_value(reject_unknown_play_time and 'on' or 'off')
		end
		LobbySettings:ResetStatus()
		LobbySettings:Save()
	end

	function MenuCallbackHandler:ls_infamy_check(data)
		return data:value() <= managers.experience:current_rank()
	end
end)

local function _insertmenuitems(nodes)
	if Global.statistics_manager and Global.statistics_manager.play_time.minutes > 0 then
		-- qued
	else
		DelayedCalls:Add('DelayedModLS_insertmenuitems', 1, function()
			_insertmenuitems(nodes)
		end)
		return
	end

	LobbySettings.egs_item_infamy = LobbySettings:InsertInfamyLimiter(nodes.edit_game_settings)
	LobbySettings.egs_item_max_players = LobbySettings:InsertPlayerLimiter(nodes.edit_game_settings)
	LobbySettings.egs_item_max_bots = LobbySettings:InsertBotLimiter(nodes.edit_game_settings)
	LobbySettings.egs_item_reject_vac = LobbySettings:InsertRejectVACed(nodes.edit_game_settings)
	LobbySettings.egs_item_reject_play_time_threshold = LobbySettings:InsertRejectPlayTime(nodes.edit_game_settings)
	LobbySettings.egs_item_reject_unknown_play_time = LobbySettings:InsertRejectUnknownPlayTime(nodes.edit_game_settings)
end

Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_LobbySettings', function(menu_manager, nodes)
	if nodes.edit_game_settings then
		_insertmenuitems(nodes)
	end
end)

function LobbySettings:InsertInfamyLimiter(node)
	local data = {
		type = 'MenuItemMultiChoice'
	}

	for i = 0, 25 do
		local option = {
			_meta = 'option',
			localize = false,
			text_id = i,
			value = i,
			visible_callback = 'ls_infamy_check'
		}
		table.insert(data, option)
	end

	local params = {
		name = 'ls_multi_infamy_permission',
		text_id = 'ls_menu_infamy_permission',
		help_id = 'ls_menu_infamy_permission_help',
		callback = 'ls_choice_lobby_infamy_permission',
		localize = true,
		visible_callback = 'is_multiplayer'
	}

	local item = node:create_item(data, params)
	item:set_value(Global.game_settings.infamy_permission)
	item:set_callback_handler(node.callback_handler)

	for k, v in pairs(node._items) do
		if v._parameters.name == 'lobby_reputation_permission' then
			table.insert(node._items, k, item)
			break
		end
	end

	return item
end

function LobbySettings:InsertPlayerLimiter(node)
	local data = {
		type = 'MenuItemMultiChoice'
	}

	for i = 1, tweak_data.max_players do
		local option = {
			_meta = 'option',
			localize = false,
			text_id = i,
			value = i
		}
		table.insert(data, option)
	end

	local params = {
		name = 'ls_multi_max_players',
		text_id = 'ls_menu_max_players',
		help_id = 'ls_menu_max_players_help',
		callback = 'ls_choice_lobby_max_players',
		localize = true,
		visible_callback = 'is_multiplayer'
	}

	local item = node:create_item(data, params)
	item:set_value(Global.game_settings.max_players)
	item:set_callback_handler(node.callback_handler)

	for k, v in pairs(node._items) do
		if v._parameters.name == 'lobby_permission' then
			table.insert(node._items, k, item)
			break
		end
	end

	return item
end

function LobbySettings:InsertBotLimiter(node)
	local data = {
		type = 'MenuItemMultiChoice'
	}

	for i = 0, LobbySettings.original_MAX_NR_TEAM_AI do
		local option = {
			_meta = 'option',
			localize = false,
			text_id = i,
			value = i
		}
		table.insert(data, option)
	end

	local params = {
		name = 'ls_multi_max_bots',
		text_id = 'menu_toggle_ai',
		callback = 'ls_choice_lobby_max_bots',
		localize = true
	}

	local item = node:create_item(data, params)
	item:set_value(Global.game_settings.max_bots)
	item:set_callback_handler(node.callback_handler)

	for k, v in pairs(node._items) do
		if v._parameters.name == 'toggle_ai' then
			node._items[k] = item
			break
		end
	end

	return item
end

function LobbySettings:InsertRejectVACed(node)
	local data = {
		type = 'CoreMenuItemToggle.ItemToggle',
		{
			_meta = 'option',
			icon = 'guis/textures/menu_tickbox',
			value = 'on',
			x = 24,
			y = 0,
			w = 24,
			h = 24,
			s_icon = 'guis/textures/menu_tickbox',
			s_x = 24,
			s_y = 24,
			s_w = 24,
			s_h = 24
		},
		{
			_meta = 'option',
			icon = 'guis/textures/menu_tickbox',
			value = 'off',
			x = 0,
			y = 0,
			w = 24,
			h = 24,
			s_icon = 'guis/textures/menu_tickbox',
			s_x = 0,
			s_y = 24,
			s_w = 24,
			s_h = 24
		}
	}

	local params = {
		name = 'ls_toggle_reject_vac',
		text_id = 'ls_menu_reject_vac',
		help_id = 'ls_menu_reject_vac_help',
		callback = 'ls_choice_lobby_reject_vac',
		localize = true,
		visible_callback = 'is_multiplayer'
	}

	local item = node:create_item(data, params)
	item:set_value(LobbySettings.settings.reject_vac and 'on' or 'off')
	item:set_callback_handler(node.callback_handler)

	table.insert(node._items, item)

	return item
end

function LobbySettings:InsertRejectUnknownPlayTime(node)
	local data = {
		type = 'CoreMenuItemToggle.ItemToggle',
		{
			_meta = 'option',
			icon = 'guis/textures/menu_tickbox',
			value = 'on',
			x = 24,
			y = 0,
			w = 24,
			h = 24,
			s_icon = 'guis/textures/menu_tickbox',
			s_x = 24,
			s_y = 24,
			s_w = 24,
			s_h = 24
		},
		{
			_meta = 'option',
			icon = 'guis/textures/menu_tickbox',
			value = 'off',
			x = 0,
			y = 0,
			w = 24,
			h = 24,
			s_icon = 'guis/textures/menu_tickbox',
			s_x = 0,
			s_y = 24,
			s_w = 24,
			s_h = 24
		}
	}

	local params = {
		name = 'ls_toggle_reject_unknown_play_time',
		text_id = 'ls_menu_reject_unknown_play_time',
		help_id = 'ls_menu_reject_unknown_play_time_help',
		callback = 'ls_choice_lobby_reject_unknown_play_time',
		localize = true,
		visible_callback = 'is_multiplayer'
	}

	local item = node:create_item(data, params)
	item:set_value(LobbySettings.settings.reject_unknown_play_time and 'on' or 'off')
	item:set_callback_handler(node.callback_handler)

	table.insert(node._items, item)

	return item
end

function LobbySettings:InsertRejectPlayTime(node)
	local data = {
		type = 'MenuItemMultiChoice'
	}

	local mpt = Global.statistics_manager and Global.statistics_manager.play_time.minutes / 60 or 0
	local to = math.min(1000, math.floor(mpt / 50))
	for i = 0, to do
		local option = {
			_meta = 'option',
			localize = false,
			text_id = i * 50,
			value = i * 50,
		}
		table.insert(data, option)
	end

	local params = {
		name = 'ls_multi_reject_play_time_threshold',
		text_id = 'ls_menu_reject_play_time_threshold',
		help_id = 'ls_menu_reject_play_time_threshold_help',
		callback = 'ls_choice_lobby_reject_play_time_threshold',
		localize = true,
		visible_callback = 'is_multiplayer'
	}

	local item = node:create_item(data, params)
	item:set_value(LobbySettings.settings.reject_play_time_threshold)
	item:set_callback_handler(node.callback_handler)

	table.insert(node._items, item)

	return item
end

local function _current_menu_has_buy_button()
	local menu = managers.menu:active_menu()
	local selnode = menu and menu.logic and menu.logic:selected_node()
	local buy_contract_item = selnode and selnode:item('buy_contract')
	return not not buy_contract_item
end

local function _set_difficulty(node)
	local difficulty = node:item('difficulty')
	if difficulty then
		if not difficulty:parameters().gui_node then
			if not _current_menu_has_buy_button() then
				DelayedCalls:Add('DelayedModLS_changecontractdifficulty', 0, function()
					_set_difficulty(node)
				end)
			end
			return
		end

		difficulty:set_value(LobbySettings.settings.difficulty)
		MenuCallbackHandler:change_contract_difficulty(difficulty)

		local toggle_one_down = node:item('toggle_one_down')
		if toggle_one_down then
			toggle_one_down:set_value(LobbySettings.settings.one_down and 'on' or 'off')
			MenuCallbackHandler:choice_crimenet_one_down(toggle_one_down)
		end
	end
end

local function _patch_node(node, data)
	data = data or {}

	if Global.game_settings.single_player then
		_set_difficulty(node)
		LobbySettings:InsertBotLimiter(node)
	elseif data.smart_matchmaking then
		-- qued
	elseif not data.server then
		_set_difficulty(node)
		if node:item('lobby_reputation_permission'):visible() then
			LobbySettings:InsertInfamyLimiter(node)
			LobbySettings:InsertPlayerLimiter(node)
		end
		if node:item('toggle_ai'):visible() then
			LobbySettings:InsertBotLimiter(node)
		end
	end
end

local ls_original_menucrimenetcontractinitiator_modifynode = MenuCrimeNetContractInitiator.modify_node
function MenuCrimeNetContractInitiator:modify_node(original_node, data)
	local node = ls_original_menucrimenetcontractinitiator_modifynode(self, original_node, data)
	_patch_node(node, data)
	return node
end

local ls_original_menuskirmishcontractinitiator_modifynode = MenuSkirmishContractInitiator.modify_node
function MenuSkirmishContractInitiator:modify_node(original_node, data)
	local node = ls_original_menuskirmishcontractinitiator_modifynode(self, original_node, data)
	_patch_node(node, data)
	return node
end
