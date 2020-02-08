local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.EnhancedHitmarkers = _G.EnhancedHitmarkers or {}
EnhancedHitmarkers._texture_reload_delay = 0.1
EnhancedHitmarkers._path = ModPath
EnhancedHitmarkers._data_path = SavePath .. 'enhanced_hitmarkers_options.txt'
EnhancedHitmarkers._data = {}
EnhancedHitmarkers.override_path = 'assets/mod_overrides/Enhanced Hitmarkers/guis/textures/pd2/'
EnhancedHitmarkers.texture_list = {}
EnhancedHitmarkers.settings = {
	hit_texture = 'classic hit v2.texture',
	kill_texture = 'TdlQ.texture',
}

function EnhancedHitmarkers:Reset()
	self.settings.body = 'ff5500'
	self.settings.head = '57ff00'
	self.settings.crit = 'ff00ff'
	self.settings.shake = true
	self.settings.blend_mode = 1
end

function EnhancedHitmarkers:CreateFolder(path)
	local tmp = ''
	for folder in path:gmatch('[^\\/]+') do
		tmp = tmp .. folder .. '/'
		SystemFS:make_dir(tmp)
	end
end

function EnhancedHitmarkers:InitializeModOverridesFolder()
	local must_reload_overrides = false
	if not SystemFS:exists(self.override_path) then
		log('[Enhanced Hitmarkers] Creating Enhanced Hitmarkers overrides folder...')
		self:CreateFolder(self.override_path)
		must_reload_overrides = true
	end

	if SystemFS:exists(self.override_path) then
		local overrides = file.GetFiles(self.override_path)
		local sources = file.GetFiles(self._path .. 'hitmarkers/')
		for _, filename in pairs(sources) do
			if not io.file_is_readable(self.override_path .. filename) then
				log('[Enhanced Hitmarkers] Copying ' .. filename)
				local r = SystemFS:copy_file(self._path .. 'hitmarkers/' .. filename, self.override_path .. filename)
				log('[Enhanced Hitmarkers] --> ' .. (r and 'success' or 'failure'))
			end
		end
	end

	if not io.file_is_readable(self.override_path .. 'hitconfirm.texture') then
		SystemFS:copy_file(self.override_path .. self.settings.hit_texture, self.override_path .. 'hitconfirm.texture')
	end

	if not io.file_is_readable(self.override_path .. 'hitconfirm_crit.texture') then
		SystemFS:copy_file(self.override_path .. self.settings.kill_texture, self.override_path .. 'hitconfirm_crit.texture')
	end

	if must_reload_overrides and SystemFS:exists(self.override_path) then
		DB:reload_override_mods()
	end
end

function EnhancedHitmarkers:MultiSetChoice(multi, choice)
	for _, option in ipairs(multi._all_options) do
		if option:parameters().text_id == choice then
			multi:set_value(option:parameters().value)
			return
		end
	end
end

function EnhancedHitmarkers:IsTexture(file)
	local result = false
	local fh = io.open(file, 'r')
	if fh then
		result = fh:read(3) == 'DDS'
		fh:close()
	end
	return result
end

function EnhancedHitmarkers:ListAvailableTextures()
	if #self.texture_list > 0 then return end

	self.texture_list = {}

	local menu = MenuHelper:GetMenu('eh_options_menu')
	local multi_hit = menu:item('eh_multi_texture_hit')
	local multi_kill = menu:item('eh_multi_texture_kill')

	for k, v in pairs(file.GetFiles(self.override_path)) do
		if v ~= 'hitconfirm.texture' and v ~= 'hitconfirm_crit.texture' and self:IsTexture(self.override_path .. v) then
			self.texture_list[k] = v
			local c = { _meta = 'option', text_id = v:gsub('\.[^\.]*$', ''), value = k, localize = false }
			multi_hit:add_option(CoreMenuItemOption.ItemOption:new(c))
			multi_kill:add_option(CoreMenuItemOption.ItemOption:new(c))
		end
	end

	multi_hit:_show_options(nil)
	multi_kill:_show_options(nil)

	self:MultiSetChoice(multi_hit, self.settings.hit_texture:gsub('\.[^\.]*$', ''))
	self:MultiSetChoice(multi_kill, self.settings.kill_texture:gsub('\.[^\.]*$', ''))

	multi_hit:set_enabled(not managers.hud)
	multi_kill:set_enabled(not managers.hud)
end

function EnhancedHitmarkers:DialogHelp()
	local title = managers.localization:text('eh_options_menu_title')
	local message = managers.localization:text('eh_options_info_popup_message_help')
	local menu_options = {}
	menu_options[1] = {
		text = managers.localization:text('eh_options_info_popup_close'),
		is_cancel_button = true
	}
	local help_menu = QuickMenu:new(title, message, menu_options, true)
end

function EnhancedHitmarkers:StoreColorSettings()
	self.settings.body = string.format('%02x%02x%02x', math.floor(self._data.BR * 100), math.floor(self._data.BG * 100), math.floor(self._data.BB * 100))
	self.settings.head = string.format('%02x%02x%02x', math.floor(self._data.HR * 100), math.floor(self._data.HG * 100), math.floor(self._data.HB * 100))
	self.settings.crit = string.format('%02x%02x%02x', math.floor(self._data.CR * 100), math.floor(self._data.CG * 100), math.floor(self._data.CB * 100))
end

function EnhancedHitmarkers:SettingsToData()
	self._data.BR = tonumber(string.sub(self.settings.body, 1, 2), 16) / 100
	self._data.BG = tonumber(string.sub(self.settings.body, 3, 4), 16) / 100
	self._data.BB = tonumber(string.sub(self.settings.body, 5, 6), 16) / 100

	self._data.HR = tonumber(string.sub(self.settings.head, 1, 2), 16) / 100
	self._data.HG = tonumber(string.sub(self.settings.head, 3, 4), 16) / 100
	self._data.HB = tonumber(string.sub(self.settings.head, 5, 6), 16) / 100

	self._data.CR = tonumber(string.sub(self.settings.crit, 1, 2), 16) / 100
	self._data.CG = tonumber(string.sub(self.settings.crit, 3, 4), 16) / 100
	self._data.CB = tonumber(string.sub(self.settings.crit, 5, 6), 16) / 100

	self._data.shake = self.settings.shake
	self._data.blend_mode = self.settings.blend_mode
end

function EnhancedHitmarkers:Load()
	self:Reset()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
	self:SettingsToData()
end

function EnhancedHitmarkers:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		self:StoreColorSettings()
		file:write(json.encode(self.settings))
		file:close()
	end

	if managers.hud then
		managers.hud:_create_hit_confirm()
	end
end

function EnhancedHitmarkers:GetBlendMode()
	local modes = { 'add', 'normal' }
	return modes[self.settings.blend_mode]
end

function EnhancedHitmarkers:CreateHitmarkerBitmap(i, texture, color, x, y)
	local bmp = self._panel:bitmap({
		valign = 'center',
		halign = 'center',
		visible = true,
		texture = texture,
		color = Color(color),
		layer = tweak_data.gui.MOUSE_LAYER - 50,
		blend_mode = self:GetBlendMode()
	})

	local w = bmp:texture_width()
	if w * 3 == bmp:texture_height() then
		bmp:set_texture_rect(0, math.mod(i - 1, 3) * w, w, w)
		bmp:set_height(w)
	end

	bmp:set_right(self._panel:right() - self._panel:w() * (0.35 + x))
	bmp:set_top(self._panel:h() * y)
	return bmp
end

function EnhancedHitmarkers:CreateHitBitmaps()
	if alive(self._panel) and not self._bmp_body_hit then
		self._bmp_body_hit  = self:CreateHitmarkerBitmap(1, 'guis/textures/pd2/hitconfirm', self.settings.body, 0.04, 0.24)
		self._bmp_head_hit  = self:CreateHitmarkerBitmap(2, 'guis/textures/pd2/hitconfirm', self.settings.head, 0.04, 0.375)
		self._bmp_crit_hit  = self:CreateHitmarkerBitmap(3, 'guis/textures/pd2/hitconfirm', self.settings.crit, 0.04, 0.51)
	end
end

function EnhancedHitmarkers:CreateKillBitmaps()
	if alive(self._panel) and not self._bmp_body_kill then
		self._bmp_body_kill = self:CreateHitmarkerBitmap(1, 'guis/textures/pd2/hitconfirm_crit', self.settings.body, 0.02, 0.28)
		self._bmp_head_kill = self:CreateHitmarkerBitmap(2, 'guis/textures/pd2/hitconfirm_crit', self.settings.head, 0.02, 0.415)
		self._bmp_crit_kill = self:CreateHitmarkerBitmap(3, 'guis/textures/pd2/hitconfirm_crit', self.settings.crit, 0.02, 0.55)
	end
end

function EnhancedHitmarkers:RemoveBitmaps(bmps)
	if alive(self._panel) then
		for _, bmp in pairs(bmps) do
			if alive(self[bmp]) then
				self._panel:remove(self[bmp])
			end
			self[bmp] = nil
		end
	end
end

function EnhancedHitmarkers:RemoveHitBitmaps()
	self:RemoveBitmaps({ '_bmp_body_hit', '_bmp_head_hit', '_bmp_crit_hit' })
end

function EnhancedHitmarkers:RemoveKillBitmaps()
	self:RemoveBitmaps({ '_bmp_body_kill', '_bmp_head_kill', '_bmp_crit_kill' })
end

function EnhancedHitmarkers:CreatePreviewPanel()
	if self._panel or not managers.menu_component then
		return
	end

	if not managers.hud then
		TextureCache:unretrieve(Idstring('guis/textures/pd2/hitconfirm'))
		TextureCache:unretrieve(Idstring('guis/textures/pd2/hitconfirm_crit'))
	end

	self._panel = managers.menu_component._ws:panel():panel()
	self:CreateHitBitmaps()
	self:CreateKillBitmaps()
end

function EnhancedHitmarkers:DestroyPreviewPanel()
	if not alive(self._panel) then
		return
	end

	self._panel:clear()
	self._bmp_body_hit = nil
	self._bmp_body_kill = nil
	self._bmp_head_hit = nil
	self._bmp_head_kill = nil
	self._bmp_crit_hit = nil
	self._bmp_crit_kill = nil

	self._panel:parent():remove(self._panel)
	self._panel = nil

	if not managers.hud then
		TextureCache:retrieve(Idstring('guis/textures/pd2/hitconfirm'), 'NORMAL')
		TextureCache:retrieve(Idstring('guis/textures/pd2/hitconfirm_crit'), 'NORMAL')
	end
end

function EnhancedHitmarkers:UpdatePreview(bmp, color)
	if alive(self._panel) and alive(bmp) then
		bmp:set_color(Color(color))
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_EnhancedHitmarkers', function(loc)
	local language_filename

	if BLT.Localization._current == 'cht' or BLT.Localization._current == 'zh-cn' then
		language_filename = 'chinese.txt'
	end

	if not language_filename then
		local modname_to_language = {
			['Payday 2 Korean patch'] = 'korean.txt',
			['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
		}
		for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
			language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
			if language_filename then
				break
			end
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(EnhancedHitmarkers._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(EnhancedHitmarkers._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(EnhancedHitmarkers._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_EnhancedHitmarkers', function(menu_manager)
	MenuCallbackHandler.EnhancedHitmarkersHelp = function(this, item)
		EnhancedHitmarkers:DialogHelp()
	end

	MenuCallbackHandler.EnhancedHitmarkersSetRedBody = function(this, item)
		EnhancedHitmarkers._data.BR = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_body_hit, EnhancedHitmarkers.settings.body)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_body_kill, EnhancedHitmarkers.settings.body)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetGreenBody = function(this, item)
		EnhancedHitmarkers._data.BG = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_body_hit, EnhancedHitmarkers.settings.body)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_body_kill, EnhancedHitmarkers.settings.body)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetBlueBody = function(this, item)
		EnhancedHitmarkers._data.BB = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_body_hit, EnhancedHitmarkers.settings.body)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_body_kill, EnhancedHitmarkers.settings.body)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetRedHead = function(this, item)
		EnhancedHitmarkers._data.HR = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_head_hit, EnhancedHitmarkers.settings.head)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_head_kill, EnhancedHitmarkers.settings.head)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetGreenHead = function(this, item)
		EnhancedHitmarkers._data.HG = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_head_hit, EnhancedHitmarkers.settings.head)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_head_kill, EnhancedHitmarkers.settings.head)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetBlueHead = function(this, item)
		EnhancedHitmarkers._data.HB = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_head_hit, EnhancedHitmarkers.settings.head)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_head_kill, EnhancedHitmarkers.settings.head)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetRedCrit = function(this, item)
		EnhancedHitmarkers._data.CR = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_crit_hit, EnhancedHitmarkers.settings.crit)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_crit_kill, EnhancedHitmarkers.settings.crit)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetGreenCrit = function(this, item)
		EnhancedHitmarkers._data.CG = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_crit_hit, EnhancedHitmarkers.settings.crit)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_crit_kill, EnhancedHitmarkers.settings.crit)
	end

	MenuCallbackHandler.EnhancedHitmarkersSetBlueCrit = function(this, item)
		EnhancedHitmarkers._data.CB = tonumber(item:value())
		EnhancedHitmarkers:StoreColorSettings()
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_crit_hit, EnhancedHitmarkers.settings.crit)
		EnhancedHitmarkers:UpdatePreview(EnhancedHitmarkers._bmp_crit_kill, EnhancedHitmarkers.settings.crit)
	end

	MenuCallbackHandler.EnhancedHitmarkersChangedFocus = function(node, focus)
		if focus then
			local menu = MenuHelper:GetMenu('eh_options_menu')
			local multi_blend_mode = menu:item('eh_multi_set_blend_mode')
			multi_blend_mode:set_enabled(not managers.hud)

			EnhancedHitmarkers:ListAvailableTextures()
			EnhancedHitmarkers:CreatePreviewPanel()
		else
			EnhancedHitmarkers:DestroyPreviewPanel()
		end
	end

	MenuCallbackHandler.EnhancedHitmarkersSetTextureHit = function(this, item)
		local texture_name = EnhancedHitmarkers.texture_list[item:value()]
		if SystemFS:copy_file(EnhancedHitmarkers.override_path..texture_name, EnhancedHitmarkers.override_path .. 'hitconfirm.texture') then
			EnhancedHitmarkers.settings.hit_texture = texture_name
			EnhancedHitmarkers:Save()
			EnhancedHitmarkers:RemoveHitBitmaps()
			DelayedCalls:Remove('DelayedCreateHitBitmaps')
			DelayedCalls:Add('DelayedCreateHitBitmaps', EnhancedHitmarkers._texture_reload_delay, function() EnhancedHitmarkers:CreateHitBitmaps() end)
		end
	end

	MenuCallbackHandler.EnhancedHitmarkersSetTextureKill = function(this, item)
		local texture_name = EnhancedHitmarkers.texture_list[item:value()]
		if SystemFS:copy_file(EnhancedHitmarkers.override_path..texture_name, EnhancedHitmarkers.override_path .. 'hitconfirm_crit.texture') then
			EnhancedHitmarkers.settings.kill_texture = texture_name
			EnhancedHitmarkers:Save()
			EnhancedHitmarkers:RemoveKillBitmaps()
			DelayedCalls:Remove('DelayedCreateKillBitmaps')
			DelayedCalls:Add('DelayedCreateKillBitmaps', EnhancedHitmarkers._texture_reload_delay, function() EnhancedHitmarkers:CreateKillBitmaps() end)
		end
	end

	MenuCallbackHandler.EnhancedHitmarkersSetShake = function(this, item)
		EnhancedHitmarkers.settings.shake = item:value() == 'on' and true or false
	end

	MenuCallbackHandler.EnhancedHitmarkersSetBlendMode = function(this, item)
		EnhancedHitmarkers.settings.blend_mode = item:value()
		EnhancedHitmarkers:DestroyPreviewPanel()
		EnhancedHitmarkers:CreatePreviewPanel()
	end
	
	MenuCallbackHandler.EnhancedHitmarkersReset = function(this, item)
		EnhancedHitmarkers:Reset()
		EnhancedHitmarkers:SettingsToData()
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_body_r'] = true}, EnhancedHitmarkers._data.BR)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_body_g'] = true}, EnhancedHitmarkers._data.BG)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_body_b'] = true}, EnhancedHitmarkers._data.BB)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_head_r'] = true}, EnhancedHitmarkers._data.HR)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_head_g'] = true}, EnhancedHitmarkers._data.HG)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_head_b'] = true}, EnhancedHitmarkers._data.HB)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_crit_r'] = true}, EnhancedHitmarkers._data.CR)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_crit_g'] = true}, EnhancedHitmarkers._data.CG)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_slider_colour_crit_b'] = true}, EnhancedHitmarkers._data.CB)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_multi_set_blend_mode'] = true}, EnhancedHitmarkers._data.blend_mode)
		MenuHelper:ResetItemsToDefaultValue(item, {['eh_toggle_shake'] = true}, EnhancedHitmarkers._data.shake)
		EnhancedHitmarkers:Save()
	end

	MenuCallbackHandler.EnhancedHitmarkersSave = function(this, item)
		EnhancedHitmarkers:Save()
		EnhancedHitmarkers.texture_list = {}
	end

	EnhancedHitmarkers:Load()
	EnhancedHitmarkers:InitializeModOverridesFolder()
	MenuHelper:LoadFromJsonFile(EnhancedHitmarkers._path .. 'menu/options.txt', EnhancedHitmarkers, EnhancedHitmarkers._data)
end)
