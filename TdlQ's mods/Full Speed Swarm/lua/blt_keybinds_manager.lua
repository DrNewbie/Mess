function BLTKeybind:_SetKey(idx, key)
	if not idx then
		return false
	end

	if key == '' then
		self._key.idstring = nil
		self._key.input = nil
	elseif string.find(key, 'mouse wheel ') == 1 then
		self._key.idstring = Idstring(key)
		self._key.input = Input:mouse()
	elseif string.find(key, 'mouse ') == 1 then
		self._key.idstring = Idstring(key:sub(7))
		self._key.input = Input:mouse()
	else
		self._key.idstring = Idstring(key)
		self._key.input = Input:keyboard()
	end

	log(string.format('[Keybind] Bound %s to %s', tostring(self:Id()), tostring(key)))
	self._key[idx] = key
end

function BLTKeybindsManager:update(t, dt, state)
	-- Don't run while chatting
	if self.fs_editing then
		return
	end

	-- Run keybinds
	for _, bind in ipairs(self.fs_filtered_keybinds) do
		local keys = bind._key
		local kids = keys.idstring
		if kids and keys.input:pressed(kids)then
			bind:Execute()
		end
	end
end

local state = Global.load_level and BLTKeybind.StateGame or BLTKeybind.StateMenu

local fs_original_bltkeybindsmanager_registerkeybind = BLTKeybindsManager.register_keybind
function BLTKeybindsManager:register_keybind(...)
	local bind = fs_original_bltkeybindsmanager_registerkeybind(self, ...)
	if bind:CanExecuteInState(state) and bind:ParentMod():IsEnabled() then
		table.insert(self.fs_filtered_keybinds, bind)
	end
	return bind
end


local BLT = BLT

local _state_menu = BLTKeybind.StateMenu
Hooks:Add('MenuUpdate', 'Base_Keybinds_MenuUpdate', function(t, dt)
	BLT.Keybinds:update(t, dt, _state_menu)
end)

local _state_game = BLTKeybind.StateGame
Hooks:Add('GameSetupUpdate', 'Base_Keybinds_GameStateUpdate', function(t, dt)
	BLT.Keybinds:update(t, dt, _state_game)
end)

local filtered_keybinds = {}
for _, bind in ipairs(BLT.Keybinds:keybinds()) do
	local keys = bind._key
	if keys.pc and keys.pc ~= '' then
		if bind:CanExecuteInState(state) and bind:ParentMod():IsEnabled() then
			bind:_SetKey('pc', keys.pc)
			table.insert(filtered_keybinds, bind)
		end
	end
end
BLT.Keybinds.fs_filtered_keybinds = filtered_keybinds


BLT.Keybinds.fs_editor = {}
function BLTKeybindsManager:enter_edit(source)
	self.fs_editor[source] = true
	self.fs_editing = true
end

function BLTKeybindsManager:exit_edit(source)
	self.fs_editor[source] = nil
	self.fs_editing = table.size(self.fs_editor) > 0
end

DelayedCalls:Add('DelayedModFSS_keyboard_typing_stuff', 0, function()
	if HUDManager then
		Hooks:PostHook(HUDManager, 'set_chat_focus', 'HUDManagerSetChatFocus_FSS', function(self, focus)
			if focus then
				BLT.Keybinds:enter_edit('HUDChat')
			else
				BLT.Keybinds:exit_edit('HUDChat')
			end
		end)

		Hooks:PostHook(MenuManager, 'open_menu', 'MenuManagerOpenMenu_FSS', function(self, node_name, parameter_list)
			if node_name == 'menu_pause' then
				BLT.Keybinds:enter_edit('menu_pause')
			end
		end)

		Hooks:PostHook(MenuManager, 'close_menu', 'MenuManagerCloseMenu_FSS', function(self, menu_name)
			if menu_name == 'menu_pause' then
				BLT.Keybinds:exit_edit('menu_pause')
			end
		end)
	end

	Hooks:PostHook(MenuItemInput, '_set_enabled', 'MenuItemInputSetEnabled_FSS', function(self, enabled)
		if enabled then
			BLT.Keybinds:enter_edit('MenuItemInput')
		else
			BLT.Keybinds:exit_edit('MenuItemInput')
		end
	end)

	Hooks:PostHook(MenuNodeGui, 'activate_customize_controller', 'MenuNodeGuiActivateCustomizeController_FSS', function(self)
		BLT.Keybinds:enter_edit('MenuItemCustomizeController')
	end)

	Hooks:PostHook(MenuNodeGui, '_end_customize_controller', 'MenuNodeGuiEndCustomizeController_FSS', function(self)
		BLT.Keybinds:exit_edit('MenuItemCustomizeController')
	end)
end)
