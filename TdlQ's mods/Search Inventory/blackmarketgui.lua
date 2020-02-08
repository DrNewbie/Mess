local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_SearchInventory', function(loc)
	local text = string.trim(loc:text('menu_cn_filters_sidebar', {btn = ''}))
	loc:add_localized_strings({si_filter = text}, true)
end)

local si_original_blackmarketgui_close = BlackMarketGui.close
function BlackMarketGui:close()
	si_original_blackmarketgui_close(self)
	SearchInventory:reset_filters()
end

local si_original_blackmarketgui_setup = BlackMarketGui._setup
function BlackMarketGui:_setup(is_start_page, component_data)
	local dont_add_extra_button
	if not component_data then
		dont_add_extra_button = true
	elseif component_data.custom_callback then
		dont_add_extra_button = true
	elseif component_data.buying_weapon or component_data.topic_id == 'bm_menu_buy_mask_title' then
		dont_add_extra_button = true
	elseif managers.blackmarket:get_hold_crafted_item() then
		dont_add_extra_button = true
	else
		local category = component_data.category
		if category == 'primaries'
		or category == 'secondaries'
		or category == 'masks'
		or component_data.topic_id == 'bm_menu_customize_mask_title'
		or component_data.topic_id == 'bm_menu_melee_weapons'
		then
			-- qued
		else
			dont_add_extra_button = true
		end
	end
	self.si_extra_button_added = not dont_add_extra_button

	si_original_blackmarketgui_setup(self, is_start_page, component_data)

	if dont_add_extra_button then
		return
	end

	if alive(self.mws_bp_switch_panel) and self.mws_bp_switch_panel:parent() == self._panel then
		self.mws_bp_switch_panel:set_height(self.mws_bp_switch_panel:height() + 20)
	else
		self.mws_bp_switch_panel = self._panel:panel({
			w = self._buttons:w(),
			h = 30,
		})
		self.mws_bp_switch_panel:set_right(self._panel:w())
	end
	self.mws_bp_switch_panel:set_bottom(self._weapon_info_panel:y() + 2)

	local btn_data = {
		prio = 1,
		name = 'si_filter',
		pc_btn = 'menu_toggle_filters',
		callback = callback(self, self, 'si_filter_callback')
	}
	self.si_filter_btn = BlackMarketGuiButtonItem:new(self.mws_bp_switch_panel, btn_data, 10)
	self.si_filter_btn._data.prio = 5 -- ugly trick for double-click
	self._btns['si_filter'] = self.si_filter_btn

	self.si_info_text_id = #self._info_texts + 1
	self.si_info_text = self._panel:text({
		w = self.mws_bp_switch_panel:w(),
		h = 25,
		text = SearchInventory:get_filter_str(),
		name = 'info_text_' .. self.si_info_text_id,
		layer = 1,
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		color = tweak_data.screen_colors.risk
	})
	self.si_info_text:set_bottom(self.mws_bp_switch_panel:top() + 2)
	self.si_info_text:set_left(self.mws_bp_switch_panel:left())

	self.si_info_texts_bg = self._panel:rect({
		alpha = 0.2,
		visible = false,
		layer = 0,
		color = Color.black
	})
	self.si_info_texts_bg:set_shape(self.si_info_text:shape())

	self:show_btns(self._selected_slot)
end

local si_original_blackmarketgui_showbtns = BlackMarketGui.show_btns
function BlackMarketGui:show_btns(...)
	si_original_blackmarketgui_showbtns(self, ...)

	local btn = self._btns['si_filter']
	if btn then
		btn:set_text_params()
		btn:show()
		self._controllers_pc_mapping[Idstring(btn._data.pc_btn):key()] = btn
	end
end

function BlackMarketGui:si_filter_callback(data)
	self:si_start_rename_item()
end

function BlackMarketGui:si_start_rename_item()
	if not self.si_renaming_item then
		self.si_info_texts_bg:set_visible(true)
		self.si_renaming_item = SearchInventory:get_filter_str()
		self.si_original_search_text = self.si_renaming_item

		self._ws:connect_keyboard(Input:keyboard())
		self._panel:enter_text(callback(self, self, 'si_enter_text'))
		self._panel:key_press(callback(self, self, 'si_key_press'))
		self._panel:key_release(callback(self, self, 'si_key_release'))
		self._rename_caret = self._panel:rect({
			name = 'caret',
			h = 0,
			y = 0,
			w = 0,
			x = 0,
			layer = 2,
			color = Color(0.05, 1, 1, 1)
		})
		self._rename_caret:animate(self.blink)
		self._caret_connected = true

		self:update_info_text()
	end
end

function BlackMarketGui:si_stop_rename_item()
	if alive(self._panel) and self.si_renaming_item then
		self.si_info_texts_bg:set_visible(false)
		self.si_renaming_item = nil

		if self._caret_connected then
			self._ws:disconnect_keyboard()
			self._panel:enter_text(nil)
			self._panel:key_press(nil)
			self._panel:key_release(nil)
			self._panel:remove(self._rename_caret)

			self._rename_caret = nil
			self._caret_connected = nil
		end
	end
end

function BlackMarketGui:si_cancel_rename_item()
	if self.si_renaming_item then
		self.si_info_text:set_text(self.si_original_search_text)
		SearchInventory:set_filters(self.si_original_search_text)
		self.si_info_texts_bg:set_visible(false)
		self.si_renaming_item = nil

		if self._caret_connected then
			self._ws:disconnect_keyboard()
			self._panel:enter_text(nil)
			self._panel:key_press(nil)
			self._panel:key_release(nil)
			self._panel:remove(self._rename_caret)

			self._rename_caret = nil
			self._caret_connected = nil
		end

		self._one_frame_input_delay = true

		self:update_info_text()
		self:si_refresh()
	end
end

function BlackMarketGui:si_enter_text(o, s)
	if self.si_ignore_input_until_key_release then
		return
	end

	if self.si_renaming_item then
		self.si_renaming_item = self.si_renaming_item .. tostring(s)
		self:update_info_text()
		SearchInventory:set_filters(self.si_renaming_item)
		self:si_refresh()
	end
end

function BlackMarketGui:si_key_release(o, k)
	if self.si_ignore_input_until_key_release then
		self.si_ignore_input_until_key_release = nil
	end
	self:key_release(o, k)
end

function BlackMarketGui:si_key_press(o, k)
	if self.si_ignore_input_until_key_release then
		return
	end

	local text = self.si_renaming_item
	local n = utf8.len(text)
	self._key_pressed = k

	self._panel:stop()
	self._panel:animate(callback(self, self, 'update_key_down'), k)

	if k == Idstring('backspace') then
		text = utf8.sub(text, 0, math.max(n - 1, 0))
	elseif k == Idstring('delete') then
		-- qued
	elseif k == Idstring('left') then
		-- qued
	elseif k == Idstring('right') then
		-- qued
	elseif self._key_pressed == Idstring('end') then
		-- qued
	elseif self._key_pressed == Idstring('home') then
		-- qued
	elseif k == Idstring('enter') then
		-- qued
	elseif k == Idstring('esc') then
		self:si_cancel_rename_item()
		return
	elseif k == Idstring('left ctrl') or k == Idstring('right ctrl') then
		self._key_ctrl_pressed = true
	elseif self._key_ctrl_pressed == true and k == Idstring('v') then
		return
	end

	if text ~= self.si_renaming_item then
		self.si_renaming_item = text
		self:update_info_text()
		SearchInventory:set_filters(self.si_renaming_item)
		self:si_refresh()
	end
end

local si_original_blackmarketgui_mousepressed = BlackMarketGui.mouse_pressed
function BlackMarketGui:mouse_pressed(button, x, y)
	if self._enabled and self._data[1].category ~= 'deployables' then
		if managers.menu_scene and managers.menu_scene:input_focus() then
			-- qued
		elseif self.si_renaming_item then
			self:si_stop_rename_item()
			return
		end
	end

	return si_original_blackmarketgui_mousepressed(self, button, x, y)
end

local si_original_blackmarketgui_confirmpressed = BlackMarketGui.confirm_pressed
function BlackMarketGui:confirm_pressed()
	if self._enabled and self.si_renaming_item then
		self:si_stop_rename_item()
		return
	end

	return si_original_blackmarketgui_confirmpressed(self)
end

local si_original_blackmarketgui_updateinfotext = BlackMarketGui.update_info_text
function BlackMarketGui:update_info_text()
	si_original_blackmarketgui_updateinfotext(self)

	if self.si_renaming_item and self._rename_caret then
		local info_text = self.si_info_text
		info_text:set_text(self.si_renaming_item == '' and ' ' or self.si_renaming_item)
		local x, y, w, h = info_text:text_rect()

		if self.si_renaming_item == '' then
			w = 0
		end

		self._rename_caret:set_w(2)
		self._rename_caret:set_h(h)
		self._rename_caret:set_world_position(x + w, y)
	end
end

local si_original_blackmarketgui_moveup = BlackMarketGui.move_up
function BlackMarketGui:move_up()
	if not self.si_renaming_item then
		return si_original_blackmarketgui_moveup(self)
	end
end

local si_original_blackmarketgui_movedown = BlackMarketGui.move_down
function BlackMarketGui:move_down()
	if not self.si_renaming_item then
		return si_original_blackmarketgui_movedown(self)
	end
end

local si_original_blackmarketgui_moveleft = BlackMarketGui.move_left
function BlackMarketGui:move_left()
	if not self.si_renaming_item then
		return si_original_blackmarketgui_moveleft(self)
	end
end

local si_original_blackmarketgui_moveright = BlackMarketGui.move_right
function BlackMarketGui:move_right()
	if not self.si_renaming_item then
		return si_original_blackmarketgui_moveright(self)
	end
end

local si_original_blackmarketgui_nextpage = BlackMarketGui.next_page
function BlackMarketGui:next_page(...)
	if not self.si_renaming_item then
		return si_original_blackmarketgui_nextpage(self, ...)
	end
end

local si_original_blackmarketgui_previouspage = BlackMarketGui.previous_page
function BlackMarketGui:previous_page(...)
	if not self.si_renaming_item then
		return si_original_blackmarketgui_previouspage(self, ...)
	end
end

local si_original_blackmarketgui_pressbutton = BlackMarketGui.press_button
function BlackMarketGui:press_button(...)
	if not self.si_renaming_item then
		return si_original_blackmarketgui_pressbutton(self, ...)
	end
end

local si_original_blackmarketgui_specialbtnpressed = BlackMarketGui.special_btn_pressed
function BlackMarketGui:special_btn_pressed(button)
	if not self.si_renaming_item then
		if button == Idstring('menu_toggle_filters') then
			self.si_ignore_input_until_key_release = true
		end
		return si_original_blackmarketgui_specialbtnpressed(self, button)
	end
end

local si_original_blackmarketgui_setselectedtab = BlackMarketGui.set_selected_tab
function BlackMarketGui:set_selected_tab(...)
	si_original_blackmarketgui_setselectedtab(self, ...)
	self:si_refresh()
end

local si_original_blackmarketgui_postreload = BlackMarketGui._post_reload
function BlackMarketGui:_post_reload()
	si_original_blackmarketgui_postreload(self)
	self:si_refresh()
end

function BlackMarketGui:si_refresh()
	local tab = self._tabs[self._selected]
	if tab then
		local nr = 0
		local identifier = tab._data and tab._data.identifier
		if identifier == self.identifiers.weapon or identifier == self.identifiers.melee_weapon then
			nr = (self._selected - 1) * tweak_data.gui.WEAPON_ROWS_PER_PAGE * tweak_data.gui.WEAPON_COLUMNS_PER_PAGE
		elseif identifier == self.identifiers.mask then
			nr = (self._selected - 1) * tweak_data.gui.MASK_ROWS_PER_PAGE * tweak_data.gui.MASK_COLUMNS_PER_PAGE
		elseif identifier == self.identifiers.mask_mod then
			-- qued
		end

		for i, slot in pairs(tab._slots) do
			slot.si_index = i + nr
			slot:refresh()
		end
	end
end

local si_original_blackmarketguislotitem_init = BlackMarketGuiSlotItem.init
function BlackMarketGuiSlotItem:init(main_panel, data, x, y, w, h)
	si_original_blackmarketguislotitem_init(self, main_panel, data, x, y, w, h)

	if self.rect_bg then
		self.rect_bg:set_visible(false)
	end
end

function BlackMarketGuiSlotItem:si_match(filters)
	if self.si_text and type(filters) == 'table' then
		for _, filter in ipairs(filters) do
			if not self.si_text:find(filter) then
				return false
			end
		end
	end
	return true
end

local si_original_blackmarketguislotitem_refresh = BlackMarketGuiSlotItem.refresh
function BlackMarketGuiSlotItem:refresh()
	si_original_blackmarketguislotitem_refresh(self)

	if self.si_index and alive(self._panel) then
		self.si_text = self.si_text or managers.blackmarket:si_get_search_string(self)
		local alpha = self:si_match(SearchInventory.filters) and 1 or 0.03
		self._panel:set_alpha(alpha)
		if self._bitmap and self._data.category == 'textures' then
			self._bitmap:set_visible(alpha == 1)
		end
	end
end
