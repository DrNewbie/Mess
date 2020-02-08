local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.QuickKeyboardInput = _G.QuickKeyboardInput or blt_class(QuickMenu)

function QuickKeyboardInput:init(title, text, default_value, changed_callback, max_length, show_immediately)
	QuickKeyboardInput.super.init(self, title, text, {}, false)

	self.dialog_data.max_length = max_length
	self.dialog_data.default_value = default_value
	self.dialog_data.changed_callback = changed_callback

	if show_immediately then
		self:show()
	end

	return self
end

function QuickKeyboardInput:Show()
	if not self.visible then
		self.visible = true
		managers.system_menu:show_keyboard_input(self.dialog_data)
	end
end

_G.QuickKeyboardInputGui = _G.QuickKeyboardInputGui or class(TextBoxGui)

function QuickKeyboardInputGui:_setup_buttons_panel(...)
	local panel = QuickKeyboardInputGui.super._setup_buttons_panel(self, ...)
	panel:set_h(0)
	return panel
end

function QuickKeyboardInputGui.blink(o)
	while true do
		o:set_color(Color(0, 1, 1, 1))
		wait(0.3)
		o:set_color(Color(0.5, 1, 1, 1))
		wait(0.3)
	end
end

function QuickKeyboardInputGui:_create_text_box(ws, title, text, content_data, config)
	self.qki_content_data = content_data

	local main = QuickKeyboardInputGui.super._create_text_box(self, ws, title, text, content_data, config)

	local scroll_panel = self._scroll_panel
	local txt = scroll_panel:child('text')
	local info_area = main:child('info_area')
	local buttons_panel = info_area:child('buttons_panel')

	local config_type = config and config.type
	local preset = config_type and self.PRESETS[config_type]
	local text_blend_mode = preset and preset.text_blend_mode or config and config.text_blend_mode or 'normal'
	local font = preset and preset.font or config and config.font or tweak_data.menu.pd2_medium_font
	local font_size = preset and preset.font_size or config and config.font_size or tweak_data.menu.pd2_medium_font_size

	ws:connect_keyboard(Input:keyboard())
	main:enter_text(callback(self, self, 'qki_enter_text'))
	main:key_press(callback(self, self, 'qki_key_press'))
	main:key_release(callback(self, self, 'qki_key_release'))

	local input_value = content_data.default_value or ''
	local inputtext = self._scroll_panel:text({
		name = 'inputtext',
		wrap = true,
		align = 'left',
		halign = 'left',
		vertical = 'top',
		valign = 'top',
		layer = 1,
		text = input_value,
		visible = true,
		w = scroll_panel:w(),
		x = txt:x(),
		y = txt:bottom(),
		font = font,
		font_size = font_size,
		blend_mode = text_blend_mode
	})
	self.qki_inputtext = inputtext
	local h = inputtext:h()

	self.qki_rename_caret = self._scroll_panel:rect({
		name = 'caret',
		h = 0,
		y = 0,
		w = 0,
		x = 0,
		layer = 2,
		color = Color(0.05, 1, 1, 1)
	})
	self.qki_rename_caret:set_w(2)
	self.qki_rename_caret:set_h(h)
	self.qki_rename_caret:animate(self.blink)
	self:qki_update_caret_position()

	main:set_h(main:h() + h)
	info_area:set_h(info_area:h() + h)
	scroll_panel:set_h(scroll_panel:h() + h)

	buttons_panel:set_h(0)
	buttons_panel:set_y(main:bottom())

	return main
end

function QuickKeyboardInputGui:qki_update_caret_position()
	local _, _, w, _ = self.qki_inputtext:text_rect()
	self.qki_rename_caret:set_position(w, self.qki_inputtext:top())
end

function QuickKeyboardInputGui:qki_enter_text(o, s)
	local txt = self.qki_inputtext:text()
	if type(self.qki_content_data.max_length) ~= 'number' or utf8.len(txt) < self.qki_content_data.max_length then
		txt = txt .. tostring(s)
		self.qki_inputtext:set_text(txt)
		self:qki_update_caret_position()
	end
end

function QuickKeyboardInputGui:qki_key_press(o, k)
	self.qki_last_pressed_key = k
	if k == Idstring('backspace') then
		local txt = self.qki_inputtext:text()
		local n = utf8.len(txt)
		txt = utf8.sub(txt, 0, math.max(n - 1, 0))
		self.qki_inputtext:set_text(txt)
		self:qki_update_caret_position()

	elseif k == Idstring('enter') then
		local clbk = self.qki_content_data.changed_callback
		if type(clbk) == 'function' then
			clbk(self.qki_inputtext:text())
		end

	elseif k == Idstring('esc') then
		-- qued
	end
end

function QuickKeyboardInputGui:qki_key_release(o, k)
	-- qued
end

function QuickKeyboardInputGui:close()
	self._ws:disconnect_keyboard()
	self._text_box:enter_text(nil)
	self._text_box:key_press(nil)
	self._text_box:key_release(nil)

	QuickKeyboardInputGui.super.close(self)
end
