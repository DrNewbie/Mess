local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_textgui_setup = TextGui.setup
function TextGui:setup()
	fs_original_textgui_setup(self)
	self._panel_w = self._panel:w()
	for row, data in ipairs(self._texts_data) do
		data.moving_panel = self._panel:panel({
			visible = true,
			x = 0,
			y = 0,
			w = self._panel_w * 2,
			h = self._panel:h()
		})
	end
end

function TextGui:_create_text_gui(row)
	local data = self._texts_data[row]
	local text_data = data.texts_data[data.iterator]
	if not text_data then
		return
	end

	local color = self.COLORS[text_data.color_type or self.COLOR_TYPE]
	local font_size = text_data.font_size or self.FONT_SIZE
	local font = text_data.font or self.FONT
	local gui = text_data.cache
	if gui then
		gui:set_visible(true)
	else
		gui = data.moving_panel:text({
			text = text_data.text,
			y = 0,
			font = font,
			align = "center",
			vertical = "center",
			font_size = font_size,
			layer = 0,
			visible = true,
			color = color
		})
		if not text_data.once then
			text_data.cache = gui
		end
		if self.RENDER_TEMPLATE then
			gui:set_render_template(Idstring(self.RENDER_TEMPLATE))
		end
		if self.BLEND_MODE then
			gui:set_blend_mode(self.BLEND_MODE)
		end
		local _, _, w, h = gui:text_rect()
		if w * 2 > data.moving_panel:w() then
			data.moving_panel:set_w(data.moving_panel:w() + w * 3)
		end
		gui:set_w(w)
		gui:set_h(h)
		local y = data.moving_panel:h()
		if text_data.align_h and text_data.align_h == "bottom" then
			gui:set_bottom((row - 1) * (y / self.ROWS) + y / self.ROWS)
		else
			gui:set_center_y((row - 1) * (y / self.ROWS) + y / self.ROWS / 2)
		end
	end
	
	local x = self._panel_w
	if not self.START_RIGHT then
		if #data.guis > 0 then
			x = math.ceil(data.guis[#data.guis].gui:right()) + data.gap
		else
			x = 0
		end
	end
	gui:set_x(x)

	table.insert(data.guis, {gui = gui, once = text_data.once})
	if text_data.once then
		table.remove(data.texts_data, data.iterator)
	end
	data.iterator = data.iterator + 1
	if data.iterator > #data.texts_data then
		data.iterator = 1
	end
end

function TextGui:update(unit, t, dt)
	if not self._visible then
		return
	end

	for row, data in ipairs(self._texts_data) do
		local dguis = data.guis
		local gui_data = dguis[1]
		if not gui_data then
			if #data.texts_data > 0 then
				self:_create_text_gui(row)
				gui_data = dguis[1]
			else
				break
			end
		end

		local moving_panel = data.moving_panel
		local mpx = moving_panel:x()
		if mpx + gui_data.gui:w() + data.gap < 0 then
			if gui_data.once then
				gui_data.gui:parent():remove(gui)
			else
				gui_data.gui:set_visible(false)
			end
			table.remove(dguis, 1)
			local rem_x = dguis[1].gui:x()
			for i = 1, #dguis do
				gui_data = dguis[i]
				gui_data.gui:set_left(gui_data.gui:x() - rem_x)
			end
			mpx = mpx - data.speed * dt + rem_x
		else
			gui_data = dguis[#dguis]
			mpx = mpx - data.speed * dt
		end
		data.moving_panel:set_x(mpx)

		if mpx + gui_data.gui:right() + data.gap < self._panel_w then
			self:_create_text_gui(row)
		end
	end
end
