local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local _rip_path = ModPath
Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_RIP', function(loc)
	for _, filename in pairs(file.GetFiles(_rip_path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(_rip_path .. 'loc/' .. filename)
			break
		end
	end
	loc:load_localization_file(_rip_path .. 'loc/english.txt', false)
end)

local rip_original_blackmarketgui_init = BlackMarketGui.init
function BlackMarketGui:init(ws, fullscreen_ws, node)
	self:rip_load_page_names(node:parameters().menu_component_data)
	rip_original_blackmarketgui_init(self, ws, fullscreen_ws, node)
end

function BlackMarketGui:rip_can_rename_page(component_data)
	if type(component_data) ~= 'table' then
		return false
	elseif not component_data.category then
		return false
	end
	local ctg = component_data.category
	if ctg == 'masks' and component_data.topic_id ~= 'bm_menu_buy_mask_title' then
		return true
	elseif (ctg == 'primaries' or ctg == 'secondaries') and not component_data.buying_weapon and component_data.topic_id ~= 'bm_menu_blackmarket_title' then
		return true
	end
	return false
end

function BlackMarketGui:rip_load_page_names(component_data)
	self.rip_page_names = {}
	if self:rip_can_rename_page(component_data) then
		local filename = SavePath .. 'rip_page_names_for_' .. tostring(component_data.category) .. '.txt'
		local file = io.open(filename, 'r')
		if file then
			self.rip_page_names = json.decode(file:read('*all')) or self.rip_page_names
			file:close()
		end
	end
end

function BlackMarketGui:rip_save_page_names()
	local filename = SavePath .. 'rip_page_names_for_' .. tostring(self._data.category) .. '.txt'
	local file = io.open(filename, 'w')
	if file then
		for i = 1, #self._data do
			self.rip_page_names[i] = self.rip_page_names[i] or ''
		end
		file:write(json.encode(self.rip_page_names))
		file:close()
	end
end

local rip_original_blackmarketgui_setup = BlackMarketGui._setup
function BlackMarketGui:_setup(is_start_page, component_data)
	if self:rip_can_rename_page(component_data) then
		for i, name in pairs(self.rip_page_names) do
			if component_data[i] then
				name = name == '' and managers.localization:to_upper_text('bm_menu_page', {page = tostring(i)}) or utf8.to_upper(name)
				component_data[i].name_localized = name
			end
		end
	end
	rip_original_blackmarketgui_setup(self, is_start_page, component_data)
end

function BlackMarketGui:rip_page_name_changed_clbk(tab_id, new_name)
	local final_name = new_name == '' and managers.localization:to_upper_text('bm_menu_page', {page = tostring(tab_id)}) or utf8.to_upper(new_name)
	self._data[tab_id].name_localized = final_name
	self.rip_page_names[tab_id] = new_name
	self:rip_save_page_names()
	self:reload()
end

local rip_original_blackmarketgui_mousedoubleclick = BlackMarketGui.mouse_double_click
function BlackMarketGui:mouse_double_click(o, button, x, y)
	if self._enabled and self._highlighted and button == Idstring('0') and self:rip_can_rename_page(self._data) then
		local inside = self._tabs[self._highlighted]:inside(x, y)
		if inside == true then
			local component_data = self._node:parameters().menu_component_data
			local current_name = tostring(component_data[self._highlighted].name_localized)
			local title = managers.localization:to_upper_text('rip_change_page_name')
			local message = managers.localization:text('rip_from_x_to', {name = current_name})
			local default = self.rip_page_names[self._highlighted] or ''
			local clbk = callback(self, self, 'rip_page_name_changed_clbk', self._highlighted)
			QuickKeyboardInput:new(title, message, default, clbk, 40, true)
		end
	end
	return rip_original_blackmarketgui_mousedoubleclick(self, o, button, x, y)
end

function BlackMarketGui:rip_move_page(page_from, page_to)
	table.insert(self.rip_page_names, page_to, table.remove(self.rip_page_names, page_from))
	self:rip_save_page_names()
end