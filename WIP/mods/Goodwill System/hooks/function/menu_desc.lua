_G.GoodWillSysMain = _G.GoodWillSysMain or {}

if _G.GoodWillSysMain._hooks.menu_desc then
	return
else
	_G.GoodWillSysMain._hooks.menu_desc = true
end

Hooks:PostHook(BlackMarketGui, "update_info_text", _G.GoodWillSysMain.__Name("BMGui:update_info_text"), function(self, ...)
	local slot_data = self._slot_data
	local tab_data = self._tabs[self._selected]._data
	local identifier = tostring(tab_data.identifier)
	local category = tostring(self._tabs[self._selected]._data.category)
	if identifier == self.identifiers.character or category == "characters" then
		if type(slot_data.name) == "string" then
			local char_name = slot_data.name
			local desc_id = char_name.."_desc"
			local dead_desc = {" ", " ", managers.localization:text(desc_id)}
			local new_desc = table.concat(dead_desc, "\n")

			self:set_info_text(4, new_desc)
			
			local info_box_panel = self._panel:child("info_box_panel")
			if info_box_panel then
				pcall(function()
					self.__goodwill_bitmap = self.__goodwill_bitmap or {}
					
					local __char_var = _G.GoodWillSysMain._funcs.__Get_Point(char_name)
					
					for __i = 0, 9 do
						if self.__goodwill_bitmap[__i] and alive(self.__goodwill_bitmap[__i]) then
							self._panel:remove(self.__goodwill_bitmap[__i])
						end
					
						local __colors = Color.white
						if 100 <= __char_var and __char_var < 500 then
							__colors = Color.yellow
						elseif 500 <= __char_var and __char_var < 900 then
							__colors = Color(255, 255, 94, 15) / 255
						elseif __char_var >= 1000 then
							__colors = Color.red
						end
						
						if slot_data.unlocked then
							self.__goodwill_bitmap[__i] = self._panel:bitmap({
								name = "goodwill"..__i,
								h = 24,
								w = 24,
								x = info_box_panel:left() + 10 + 26 * __i,
								y = info_box_panel:y() + 48,
								texture = "goodwill/texture/heart",
								color = __colors,
								layer = 101
							})
							__char_var = __char_var - 1000							
						end
					end
				end)
			end
		end
	end
end)