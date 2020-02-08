local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.DragDropInventory = _G.DragDropInventory or {
	dragged_item_name = 'DragDropInventoryItem',
	from_x = 0,
	from_y = 0,
	ctg2ctg = {
		masks = 'mask',
		primaries = 'primary',
		secondaries = 'secondary'
	}
}

local ids_zero = Idstring('0')

local ddi_original_blackmarketgui_mousepressed = BlackMarketGui.mouse_pressed
function BlackMarketGui:mouse_pressed(button, x, y)
	local result = ddi_original_blackmarketgui_mousepressed(self, button, x, y)

	local data = self._data
	local slot_data = self._slot_data
	if slot_data and self._enabled and not data.is_loadout and not self._renaming_item and self._highlighted and button == ids_zero then
		local ctg = slot_data.category
		local inside = self._tabs[self._highlighted]:inside(x, y)

		if inside == true then
			if (ctg == 'masks' and data.topic_id ~= 'bm_menu_buy_mask_title' and self._highlighted ~= 1) or ((ctg == 'primaries' or ctg == 'secondaries') and not data.buying_weapon and data.topic_id ~= 'bm_menu_blackmarket_title') then
				DragDropInventory.page_src = self._highlighted
				DragDropInventory.dragging = true
				DragDropInventory.picked = true
				DragDropInventory.from_x = x
				DragDropInventory.from_y = y
			end

		elseif inside == 1 and not slot_data.empty_slot and not slot_data.locked_slot then
			if (ctg == 'masks' and slot_data.slot ~= 1 and data.topic_id ~= 'bm_menu_buy_mask_title') or ((ctg == 'primaries' or ctg == 'secondaries') and not data.buying_weapon and data.topic_id ~= 'bm_menu_blackmarket_title') then
				DragDropInventory.dragging = false
				DragDropInventory.picked = false
				DragDropInventory.from_x = x
				DragDropInventory.from_y = y
				DragDropInventory.slot_src = slot_data.slot
				DragDropInventory.slot_data = slot_data
			end
		end
	end

	return result
end

local ddi_original_blackmarketgui_mousemoved = BlackMarketGui.mouse_moved
function BlackMarketGui:mouse_moved(o, x, y)
	local grab
	local tab_h = self._highlighted and self._tabs[self._highlighted]

	if not self._enabled then
		-- qued

	elseif DragDropInventory.page_src then
		grab = true
		local name = DragDropInventory.dragged_item_name
		local bmp = self._panel:child(name)
		if not bmp then
			local texture, rect = tweak_data.hud_icons:get_icon_data('scrollbar_arrow')
			bmp = self._panel:bitmap({
				blend_mode = 'add',
				color = Color('green'),
				layer = tweak_data.gui.MOUSE_LAYER - 50,
				name = name,
				rotation = 180,
				texture = texture,
				texture_rect = rect,
			})
		end
		if tab_h then
			local x_insert = self._highlighted > DragDropInventory.page_src and tab_h._tab_panel:right() or tab_h._tab_panel:left()
			if alive(self._tab_scroll_table.panel) then
				x_insert = x_insert + self._tab_scroll_table.panel:left()
			end
			local y_insert = tab_h._grid_panel:top() - tab_h._tab_panel:h()
			bmp:set_center(x_insert, y_insert)
			bmp:set_visible(self._highlighted ~= DragDropInventory.page_src)
		else
			bmp:set_visible(false)
		end

	elseif tab_h and DragDropInventory.slot_src then
		grab = true
		if self._tab_scroll_panel:inside(x, y) and tab_h:inside(x, y) ~= 1 then
			if self._selected ~= self._highlighted then
				self:set_selected_tab(self._highlighted)
			end
		elseif tab_h:inside(x, y) == 1 then
			DragDropInventory.dragging = DragDropInventory.dragging or math.abs(x - DragDropInventory.from_x) > 5 or math.abs(y - DragDropInventory.from_y) > 5
			if DragDropInventory.dragging then
				if not DragDropInventory.picked then
					DragDropInventory.picked = true
					managers.blackmarket:pickup_crafted_item(self._slot_data.category, self._slot_data.slot)
				end

				if DragDropInventory.slot_data then
					local name = DragDropInventory.dragged_item_name
					local bmp = self._panel:child(name) or self._panel:bitmap({
						name = name,
						texture = DragDropInventory.slot_data.bitmap_texture,
						layer = tweak_data.gui.MOUSE_LAYER - 50,
					})
					bmp:set_center(x, y)
				end
			end
		end
	end

	if grab then
		ddi_original_blackmarketgui_mousemoved(self, o, x, y)
		return true, 'grab'
	end

	return ddi_original_blackmarketgui_mousemoved(self, o, x, y)
end

local ddi_original_blackmarketgui_mousereleased = BlackMarketGui.mouse_released
function BlackMarketGui:mouse_released(button, x, y)
	if button == ids_zero then
		if DragDropInventory.dragging and self._highlighted then
			local tab = self._tabs[self._highlighted]
			local inside = tab:inside(x, y)

			if inside == true and DragDropInventory.page_src and DragDropInventory.page_src ~= self._highlighted then
				if self._slot_data.category ~= 'masks' or self._highlighted ~= 1 then
					managers.blackmarket:ddi_move_page(self._slot_data.category, DragDropInventory.page_src, self._highlighted)
					if type(self.rip_move_page) == 'function' then
						self:rip_move_page(DragDropInventory.page_src, self._highlighted)
					end
					self:reload()
					self:set_selected_tab(self._highlighted)
				end

			elseif inside == 1 then
				local slot_dst = tab._slots[tab._slot_highlighted]._data
				if slot_dst and not (slot_dst.category == 'masks' and slot_dst.slot == 1) then
					managers.blackmarket:place_crafted_item(slot_dst.category, slot_dst.slot)
					if slot_dst.locked_slot then
						local unlocked_slots = slot_dst.category == 'masks' and managers.blackmarket._global.unlocked_mask_slots or managers.blackmarket._global.unlocked_weapon_slots[slot_dst.category]
						local src = DragDropInventory.slot_src
						local dst = slot_dst.slot
						unlocked_slots[dst], unlocked_slots[src] = unlocked_slots[src], unlocked_slots[dst]
					end
					self:reload()
				end
			end
		end

		self:ddi_stop()
	end

	return ddi_original_blackmarketgui_mousereleased(self, button, x, y)
end

function BlackMarketGui:ddi_stop()
	local dragged_item_obj = self._panel:child(DragDropInventory.dragged_item_name)
	if dragged_item_obj then
		self._panel:remove(dragged_item_obj)
	end
	DragDropInventory.dragging = false
	DragDropInventory.page_src = nil
	DragDropInventory.slot_src = nil
	DragDropInventory.slot_data = nil
end

local ddi_original_blackmarketgui_close = BlackMarketGui.close
function BlackMarketGui:close()
	self:ddi_stop()
	ddi_original_blackmarketgui_close(self)
end
