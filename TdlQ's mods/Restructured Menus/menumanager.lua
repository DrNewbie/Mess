local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.RestructuredMenus = _G.RestructuredMenus or {}
RestructuredMenus._path = ModPath
RestructuredMenus._data_path = SavePath .. 'restructured_menus.txt'
RestructuredMenus.settings = {
	remove_quickplay = false,
}

function RestructuredMenus:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function RestructuredMenus:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function MenuHelper:GetMenuItem(parent_menu, child_menu)
	for i, item in pairs(parent_menu._items) do
		if item._parameters.name == child_menu then
			return i, item
		end
	end
end

function MenuHelper:AddVisibleCallback(parent_menu, child_menu, callback_name)
	local _, item = self:GetMenuItem(parent_menu, child_menu)
	if item then
		item._visible_callback_name_list = item._visible_callback_name_list or {}
		table.insert(item._visible_callback_name_list, callback_name)
		item:set_callback_handler(item._callback_handler)
	end
end

function MenuHelper:AddExistingMenuItem(node, item)
	if node and item then
		table.insert(node._items, item)
	end
end

function MenuHelper:RemoveMenuItem(parent_menu, child_menu)
	local index = self:GetMenuItem(parent_menu, child_menu)
	if index then
		return table.remove(parent_menu._items, index)
	end
end

function MenuHelper:MoveMenuItem(parent_menu, moved_menu, new_pos, direction)
	local item = self:RemoveMenuItem(parent_menu, moved_menu)
	if item then
		local final_pos
		if type(new_pos) == 'number' then
			final_pos = new_pos
		elseif type(new_pos) == 'string' then
			final_pos = self:GetMenuItem(parent_menu, new_pos)
			if not final_pos then
				return
			end
			if not direction or direction == 'after' then
				final_pos = final_pos + 1
			end
		end

		if final_pos then
			table.insert(parent_menu._items, final_pos, item)
		end
	end
end

function MenuHelper:SetIcon(parent_menu, child_menu, icon, callback_name)
	local _, item = self:GetMenuItem(parent_menu, child_menu)
	if item then
		item._parameters.icon = icon
		item._parameters.icon_visible_callback = { callback_name }
		item._icon_visible_callback_name_list  = { callback_name }
		item:set_callback_handler(item._callback_handler)
	end
end

Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_SideJobsInLobbyMenu', function(menu_manager, nodes)
	local node = nodes.side_jobs
	if node then
		node:parameters().sync_state = 'payday'
	end

	node = nodes.steam_inventory
	if node then
		node:parameters().sync_state = 'payday'
	end

	node = nodes.main
	if node then
		MenuHelper:AddMenuItem(node, 'side_jobs', 'menu_cn_challenge', 'menu_cn_challenge_desc', 'quickplay', 'after')
		MenuHelper:SetIcon(node, 'side_jobs', 'guis/textures/pd2/icon_reward', 'show_side_job_menu_icon')
		if RestructuredMenus.settings.remove_quickplay then
			MenuHelper:RemoveMenuItem(node, 'quickplay')
		end
	end

	node = nodes.lobby
	if node then
		MenuHelper:AddMenuItem(node, 'side_jobs', 'menu_cn_challenge', 'menu_cn_challenge_desc', 'crimenet', 'after')
		MenuHelper:SetIcon(node, 'side_jobs', 'guis/textures/pd2/icon_reward', 'show_side_job_menu_icon')
		MenuHelper:AddMenuItem(node, 'steam_inventory', 'menu_steam_inventory', 'menu_steam_inventory_help', 'inventory', 'after')
		MenuHelper:AddVisibleCallback(node, 'custom_safehouse', 'is_not_server')
		MenuHelper:AddVisibleCallback(node, 'story_missions', 'is_not_server')
	end

	node = nodes.crime_spree_lobby
	if node then
		MenuHelper:AddMenuItem(node, 'side_jobs', 'menu_cn_challenge', 'menu_cn_challenge_desc', 'inventory', 'after')
		MenuHelper:SetIcon(node, 'side_jobs', 'guis/textures/pd2/icon_reward', 'show_side_job_menu_icon')
	end
end)

RestructuredMenus:Load()
RestructuredMenus:Save()
