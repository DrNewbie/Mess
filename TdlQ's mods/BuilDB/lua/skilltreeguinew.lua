if not BuilDB then
	dofile(ModPath .. 'lua/_buildb.lua')
end

local bdb_original_skilltreeguinew_setup = NewSkillTreeGui._setup
function NewSkillTreeGui:_setup()
	bdb_original_skilltreeguinew_setup(self)

	local skill_import_button = self._panel:text({
		name = 'import_skills_button',
		text = managers.localization:to_upper_text('buildb_import'),
		align = 'left',
		vertical = 'top',
		font_size = tweak_data.menu.pd2_medium_font_size - 4,
		font = tweak_data.menu.pd2_medium_font,
		color = Color.black,
		blend_mode = 'add',
	})
	local _, _, w, h = skill_import_button:text_rect()
	skill_import_button:set_size(w, h)
	skill_import_button:set_bottom(self._panel:bottom())
	skill_import_button:set_right(self._panel:child('SkillsRootPanel'):right())
	self._skill_import_highlight = true

	local open_buildb_button = self._panel:text({
		name = 'open_buildb_button',
		text = managers.localization:to_upper_text('buildb_open_db'),
		align = 'center',
		vertical = 'top',
		font_size = tweak_data.menu.pd2_medium_font_size - 4,
		font = tweak_data.menu.pd2_medium_font,
		color = Color.black,
		blend_mode = 'add',
	})
	_, _, w, h = open_buildb_button:text_rect()
	open_buildb_button:set_size(w, h)
	open_buildb_button:set_top(skill_import_button:top())
	open_buildb_button:set_right(skill_import_button:left() - 20)
	self._open_buildb_highlight = true

	local skill_save_button = self._panel:text({
		name = 'save_skills_button',
		text = managers.localization:to_upper_text('buildb_save_current'),
		align = 'right',
		vertical = 'top',
		font_size = tweak_data.menu.pd2_medium_font_size - 4,
		font = tweak_data.menu.pd2_medium_font,
		color = Color.black,
		blend_mode = 'add',
	})
	_, _, w, h = skill_save_button:text_rect()
	skill_save_button:set_size(w, h)
	skill_save_button:set_top(skill_import_button:top())
	skill_save_button:set_right(open_buildb_button:left() - 20)
	self._skill_save_highlight = true

	local skill_export_button = self._panel:text({
		name = 'export_skills_button',
		text = managers.localization:to_upper_text('buildb_export_to_' .. BuilDB.settings.export_format),
		align = 'right',
		vertical = 'top',
		font_size = tweak_data.menu.pd2_medium_font_size - 4,
		font = tweak_data.menu.pd2_medium_font,
		color = Color.black,
		blend_mode = 'add',
	})
	_, _, w, h = skill_export_button:text_rect()
	skill_export_button:set_size(w, h)
	skill_export_button:set_top(skill_import_button:top())
	skill_export_button:set_right(skill_save_button:left() - 20)
	self._skill_export_highlight = true

	local clipboard_url_button = self._panel:text({
		name = 'clipboard_url_button',
		text = managers.localization:to_upper_text('buildb_copy_to_clipboard'),
		align = 'right',
		vertical = 'top',
		font_size = tweak_data.menu.pd2_medium_font_size - 4,
		font = tweak_data.menu.pd2_medium_font,
		color = Color.black,
		blend_mode = 'add',
	})
	_, _, w, h = clipboard_url_button:text_rect()
	clipboard_url_button:set_size(w, h)
	clipboard_url_button:set_top(skill_import_button:top())
	clipboard_url_button:set_right(skill_export_button:left() - 20)
	self._clipboard_url_highlight = true
end

function NewSkillTreeGui:check_buildb_button(x, y, panel_name, highlight_var_name)
	local inside = false

	if x and y and self._panel:child(panel_name):inside(x, y) then
		if not self[highlight_var_name] then
			self[highlight_var_name] = true
			self._panel:child(panel_name):set_color(tweak_data.screen_colors.button_stage_2)
			managers.menu_component:post_event('highlight')
		end
		inside = true
	elseif self[highlight_var_name] then
		self[highlight_var_name] = false
		self._panel:child(panel_name):set_color(managers.menu:is_pc_controller() and tweak_data.screen_colors.button_stage_3 or Color.black)
	end

	return inside
end

local bdb_original_skilltreeguinew_mousepressed = NewSkillTreeGui.mouse_pressed
function NewSkillTreeGui:mouse_pressed(button, x, y)
	if self._renaming_skill_switch then
		self:_stop_rename_skill_switch()
		return
	end
	if not self._enabled then
		return
	end

	bdb_original_skilltreeguinew_mousepressed(self, button, x, y)

	if button == Idstring('0') then
		if self._panel:child('clipboard_url_button'):inside(x, y) then
			Application:set_clipboard(BuilDB:GetBuildUrl())
			return
		elseif self._panel:child('export_skills_button'):inside(x, y) then
			Steam:overlay_activate('url', BuilDB:GetBuildUrl())
			return
		elseif self._panel:child('save_skills_button'):inside(x, y) then
			BuilDB:SaveCurrentBuild()
		elseif self._panel:child('open_buildb_button'):inside(x, y) then
			if BuilDB:CheckDB() then
				os.execute(string.format('start "%s" "%s"', BuilDB.settings.text_editor, BuilDB._db_path))
			end
			return
		elseif self._panel:child('import_skills_button'):inside(x, y) then
			BuilDB:ShowMenu()
			return
		end
	end
end

local bdb_original_skilltreeguinew_mousemoved = NewSkillTreeGui.mouse_moved
function NewSkillTreeGui:mouse_moved(o, x, y)
	local inside, pointer = bdb_original_skilltreeguinew_mousemoved(self, o, x, y)

	if self._enabled then
		if self:check_buildb_button(x, y, 'clipboard_url_button', '_clipboard_url_highlight') then
			inside = true
			pointer = 'link'
		elseif self:check_buildb_button(x, y, 'export_skills_button', '_skill_export_highlight') then
			inside = true
			pointer = 'link'
		elseif self:check_buildb_button(x, y, 'save_skills_button', '_skill_save_highlight') then
			inside = true
			pointer = 'link'
		elseif self:check_buildb_button(x, y, 'import_skills_button', '_skill_import_highlight') then
			inside = true
			pointer = 'link'
		elseif self:check_buildb_button(x, y, 'open_buildb_button', '_open_buildb_highlight') then
			inside = true
			pointer = 'link'
		end
	end

	return inside, pointer
end
