local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.BagContour = _G.BagContour or {}
BagContour._path = ModPath
BagContour._data_path = SavePath .. 'bag_contour.txt'
BagContour._ovrd_path = SavePath .. 'bag_contour_overrides.txt'
BagContour._bags = {}
BagContour._ptexts = {}
BagContour._overrides = {}
BagContour.settings = {}
BagContour._custom_colors_menu_id = 'bagcontour_custom'
BagContour._customize_color_menu_id = 'bagcontour_customize'

local ids_unit = Idstring('unit')
local ids_lootbag_name = Idstring('units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag')
local ids_bodybag_name = Idstring('units/payday2/pickups/gen_pku_bodybag/gen_pku_bodybag')

function BagContour:Reset()
	self.settings = {
		LR = 2.00,
		LG = 2.55,
		LB = 0,
		HR = 2.55,
		HG = 0,
		HB = 0.40,
		BR = 0.20,
		BG = 0.80,
		BB = 1
	}
end

function BagContour:LoadOverrides()
	self._overrides = {}
	local file = io.open(self._ovrd_path, 'r')
	if file then
		for _, line in ipairs(string.split(file:read('*all') or '', '\n')) do
			local r, g, b, carry_id = line:match('^RGB%((%d+),(%d+),(%d+)%)[ 	]+([^ 	]*)$')
			if carry_id then
				self._overrides[carry_id] = Vector3(r / 255, g / 255, b / 255)
			end
		end
		file:close()
	end
end

function BagContour:SaveOverrides()
	local file = io.open(self._ovrd_path, 'w')
	if file then
		local out = {}
		for carry_id, data in pairs(tweak_data.carry) do
			if data.type then
				local v = self._overrides[carry_id]
				if v then
					table.insert(out, string.format('RGB(%i,%i,%i)	%s', v[1] * 255, v[2] * 255, v[3] * 255, carry_id))
				else
					table.insert(out, 'weight		' .. carry_id)
				end
			end
		end
		table.sort(out, function(a, b) return a < b end)
		file:write(table.concat(out, '\n'))
		file:close()
	end
end

function BagContour:UpdateOverrides()
	self:LoadOverrides()
	self:SaveOverrides()
end

function BagContour:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all'))) do
			self.settings[k] = v
		end
		file:close()
	else
		self:Reset()
	end
end

function BagContour:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function BagContour:RenewLabelExamples()
	local carry_by_msm = {}
	for carry_id, data in pairs(tweak_data.carry) do
		if data.type and data.type ~= 'being' then
			local msm = tweak_data.carry.types[data.type].move_speed_modifier
			carry_by_msm[msm] = carry_by_msm[msm] or {}
			table.insert(carry_by_msm[msm], carry_id)
		end
	end

	local sorted_msms = {}
	for msm, _ in pairs(self.move_speed_modifiers) do
		table.insert(sorted_msms, msm)
	end
	table.sort(sorted_msms, function(a, b) return a > b end)

	self.examples = {}
	self._labels = {}
	local i = 0
	for _, msm in pairs(sorted_msms) do
		if carry_by_msm[msm] then
			i = i + 1
			local rnd = carry_by_msm[msm][math.random(#carry_by_msm[msm])]
			table.insert(self.examples, rnd)
			self._labels[i] = tweak_data.carry[rnd].name_id
		end
	end
end

function BagContour:SetContourColors()
	self.move_speed_modifiers = {}
	local msm_min = 10
	local msm_max = 0
	for carry_id, data in pairs(tweak_data.carry.types) do
		if not data.type and data.move_speed_modifier and data.type ~= 'being' and not self.move_speed_modifiers[data.move_speed_modifier] then
			self.move_speed_modifiers[data.move_speed_modifier] = 1
			msm_min = math.min(msm_min, data.move_speed_modifier)
			msm_max = math.max(msm_max, data.move_speed_modifier)
		end
	end

	local color_light = { self.settings.LR / 2.55, self.settings.LG / 2.55, self.settings.LB / 2.55 }
	local color_heavy = { self.settings.HR / 2.55, self.settings.HG / 2.55, self.settings.HB / 2.55 }
	local msm_amplitude = msm_max - msm_min
	for msm, _ in pairs(self.move_speed_modifiers) do
		local ratio = (msm_max - msm) / msm_amplitude
		self.move_speed_modifiers[msm] = Vector3(
			color_light[1] + (color_heavy[1] - color_light[1]) * ratio,
			color_light[2] + (color_heavy[2] - color_light[2]) * ratio,
			color_light[3] + (color_heavy[3] - color_light[3]) * ratio
		)
	end

	for carry_id, data in pairs(tweak_data.carry) do
		if data.type then
			tweak_data.contour.interactable[carry_id] = self._overrides[carry_id] or self.move_speed_modifiers[tweak_data.carry.types[data.type].move_speed_modifier]
		end
	end

	if not self.examples then
		self:RenewLabelExamples()
	end

	for carry_id, data in pairs(tweak_data.carry) do
		if data.type == 'being' then
			tweak_data.contour.interactable[carry_id] = Vector3(self.settings.BR / 2.55, self.settings.BG / 2.55, self.settings.BB / 2.55)
		end
	end
end

function BagContour:CanHideBodyBagContour()
	if Global.game_settings.level_id == 'mad' then
		return false
	end

	return managers.groupai:state()._police_called
end

function BagContour:SetBagContour(unit, contour_id)
	if not alive(unit) then
		return
	end
	local ids_contour_color = Idstring('contour_color')
	local ids_contour_opacity = Idstring('contour_opacity')
	for _, m in ipairs(unit:get_objects_by_type(Idstring('material'))) do
		if m:variable_exists(ids_contour_color) then
			m:set_variable(ids_contour_color, tweak_data.contour.interactable[contour_id])
			m:set_variable(ids_contour_opacity, 1)
		end
	end
end

function BagContour:SetAllBagsContour()
	for i, carry_id in ipairs(self.examples) do
		self:SetBagContour(self._bags[i], carry_id)
	end
	self:SetBagContour(self._bodybag, 'person')
end

function BagContour:SetAllLabelsColor()
	for i, carry_id in ipairs(self.examples) do
		local c = tweak_data.contour.interactable[carry_id]
		self._ptexts[i]:set_color(Color(c.x, c.y, c.z))
	end
end

function BagContour:SpawnWeightBag(carry_id, h)
	local unit = World:spawn_unit(ids_lootbag_name, Vector3(30, 200, 155 - h * 50), Rotation(math.random() * 20 - 10, math.random() * 20 - 10, math.random() * 4 - 2))
	self._bags[h] = unit
	for i = 0, unit:num_bodies() - 1 do
		unit:body(i):set_keyframed()
	end
end

function BagContour:SpawnCustomBag()
	local visual_unit_name = tweak_data.carry[self._customizing_carry_id].visual_unit_name
	local ids_custom_name = visual_unit_name and Idstring(visual_unit_name)

	local drp = managers.dyn_resource.DYN_RESOURCES_PACKAGE
	if ids_custom_name and managers.dyn_resource:is_resource_ready(ids_unit, ids_custom_name, drp) then
		self:DoSpawnCustomBag(ids_custom_name)
	else
		self:DoSpawnCustomBag(ids_lootbag_name)
		-- Nope, following doesn't work
		-- self._custom_dyn_resource = ids_custom_name
		-- managers.dyn_resource:load(ids_unit, ids_custom_name, drp, callback(BagContour, BagContour, 'DoSpawnCustomBag', ids_custom_name))
	end
end

function BagContour:DoSpawnCustomBag(ids_unit_name)
	local unit = World:spawn_unit(ids_unit_name, Vector3(30, 200, 55), Rotation(math.random() * 20 - 10, math.random() * 20 - 10, math.random() * 4 - 2))
	self._custombag = unit
	for i = 0, unit:num_bodies() - 1 do
		unit:body(i):set_keyframed()
	end
	self:SetBagContour(self._custombag, self._customizing_carry_id)
end

function BagContour:SpawnBodybag()
	local unit = World:spawn_unit(ids_bodybag_name, Vector3(150, 200, -60), Rotation(0, 0, 0))
	self._bodybag = unit
	for i = 0, unit:num_bodies() - 1 do
		unit:body(i):set_keyframed()
	end
end

function BagContour:UpdateColors()
	self:SetContourColors()
	if not managers.hud then
		self:SetAllLabelsColor()
		self:SetAllBagsContour()
	end
end

function BagContour:CreateWeightLabels()
	self._panel = managers.menu_component._ws:panel():panel()

	for i, txt in ipairs(self._labels) do
		self._ptexts[i] = self._panel:text({
			text = managers.localization:text(txt),
			align = 'center',
			vertical = 'top',
			font_size = tweak_data.menu.pd2_small_font_size - 4,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.text,
		})
		local _, _, w, h = self._ptexts[i]:text_rect()
		self._ptexts[i]:set_size(w, h)
		if alive(self._bags[i]) then
			local pos = managers.menu_component._ws:world_to_screen(managers.menu_scene._camera_object, self._bags[i]:position())
			self._ptexts[i]:set_center(pos.x - 30, pos.y)
		end
	end
end

function BagContour:RemoveWeightLabels()
	if alive(self._panel) then
		self._panel:clear()
		self._panel:parent():remove(self._panel)
	end
	self._ptexts = {}
	self._panel = nil
end

function BagContour:SetScene(resource)
	if resource then
		self[resource] = true
	end

	if not self.option_menu_is_focused then
		return
	end

	if alive(self._bodybag) then
		return
	end

	if self.lootbag_is_ready and self.bodybag_is_ready then
		for i, carry_id in ipairs(self.examples) do
			self:SpawnWeightBag(carry_id, i)
		end
		self:SpawnBodybag()
		self:SetAllBagsContour()
		self:CreateWeightLabels()
		self:SetAllLabelsColor()
	end
end

function BagContour:InitWeightSliders()
	local menu = MenuHelper:GetMenu('bc_options_menu')

	for _, x in pairs({'L', 'H', 'B'}) do
		local h, s, v = CoreMath.rgb_to_hsv(
			BagContour.settings[x .. 'R'] * 100,
			BagContour.settings[x .. 'G'] * 100,
			BagContour.settings[x .. 'B'] * 100
		)
		menu:item(x .. 'H'):set_value(h)
		menu:item(x .. 'S'):set_value(s)
		menu:item(x .. 'V'):set_value(v)
	end

	managers.viewport:resolution_changed()
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_BagContour', function(loc)
	local language_filename

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

	if not language_filename then
		for _, filename in pairs(file.GetFiles(BagContour._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(BagContour._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(BagContour._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerSetupCustomMenus', 'MenuManagerSetupCustomMenus_BagContour', function(menu_manager, nodes)
	MenuHelper:NewMenu(BagContour._custom_colors_menu_id)
	MenuHelper:NewMenu(BagContour._customize_color_menu_id)
end)

Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_BagContour', function(menu_manager, nodes)
	local menu = MenuHelper:BuildMenu(BagContour._custom_colors_menu_id, {})
	menu:parameters().modifier = {BagContourCreator.modify_node}
	nodes[BagContour._custom_colors_menu_id] = menu
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_BagContour', function(menu_manager)
	MenuCallbackHandler.BagContourCustomize_ChangedFocus = function(node, focus)
		local carry_id = BagContour._customizing_carry_id
		local menu = MenuHelper:GetMenu(BagContour._customize_color_menu_id)
		local h = menu:item('bc_slider_colour_h')
		local s = menu:item('bc_slider_colour_s')
		local v = menu:item('bc_slider_colour_v')
		local use_weight = menu:item('bc_toggle_use_weight')
		if focus then
			local override = BagContour._overrides[carry_id]
			use_weight:set_value(override and 'off' or 'on')
			h:set_enabled(not not override)
			s:set_enabled(not not override)
			v:set_enabled(not not override)
			local vh, vs, vv = 0, 1, 255
			if override then
				vh, vs, vv = CoreMath.rgb_to_hsv(override.x * 255, override.y * 255, override.z * 255)
			end
			h:set_value(vh)
			s:set_value(vs)
			v:set_value(vv)
			if not managers.network:session() then
				BagContour:SpawnCustomBag()
			end

		else
			if alive(BagContour._custombag) then
				World:delete_unit(BagContour._custombag)
			end
			if BagContour._custom_dyn_resource then
				managers.dyn_resource:unload(ids_unit, BagContour._custom_dyn_resource, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
				BagContour._custom_dyn_resource = nil
			end
			if use_weight:value() == 'on' then
				BagContour._overrides[carry_id] = nil
			else
				local r, g, b = CoreMath.hsv_to_rgb(h:value(), s:value(), v:value())
				BagContour._overrides[carry_id] = Vector3(r / 255, g / 255, b / 255)
			end
			BagContour:SaveOverrides()
		end
	end

	local function _BagContourCustomize_SetHSV()
		local menu = MenuHelper:GetMenu(BagContour._customize_color_menu_id)
		local r, g, b = CoreMath.hsv_to_rgb(menu:item('bc_slider_colour_h'):value(), menu:item('bc_slider_colour_s'):value(), menu:item('bc_slider_colour_v'):value())
		local color = Vector3(r / 255, g / 255, b / 255)

		local carry_id = BagContour._customizing_carry_id
		tweak_data.contour.interactable[carry_id] = color
		BagContour._overrides[carry_id] = color
		BagContour:SetBagContour(BagContour._custombag, carry_id)
	end

	MenuCallbackHandler.BagContourCustomize_UseWeight = function(node, item)
		local checked = item:value() == 'on'
		local menu = MenuHelper:GetMenu(BagContour._customize_color_menu_id)
		menu:item('bc_slider_colour_h'):set_enabled(not checked)
		menu:item('bc_slider_colour_s'):set_enabled(not checked)
		menu:item('bc_slider_colour_v'):set_enabled(not checked)
		if checked then
			local carry_id = BagContour._customizing_carry_id
			BagContour._overrides[carry_id] = nil
			BagContour:SetContourColors()
			BagContour:SetBagContour(BagContour._custombag, carry_id)
		else
			_BagContourCustomize_SetHSV()
		end
		managers.viewport:resolution_changed()
	end

	MenuCallbackHandler.BagContourCustomize_SetHSV = function(node, item)
		_BagContourCustomize_SetHSV()
	end

	MenuCallbackHandler.BagContourChangedFocus = function(node, focus)
		BagContour.option_menu_is_focused = focus
		local drp = managers.dyn_resource.DYN_RESOURCES_PACKAGE
		if focus then
			BagContour:InitWeightSliders()
			if not managers.network:session() then

				local lootbag_ready = managers.dyn_resource:is_resource_ready(ids_unit, ids_lootbag_name, drp)
				if not lootbag_ready then
					managers.dyn_resource:load(ids_unit, ids_lootbag_name, drp, callback(BagContour, BagContour, 'SetScene', 'lootbag_is_ready'))
				end

				local bodybag_ready = managers.dyn_resource:is_resource_ready(ids_unit, ids_bodybag_name, drp)
				if not bodybag_ready then
					managers.dyn_resource:load(ids_unit, ids_bodybag_name, drp, callback(BagContour, BagContour, 'SetScene', 'bodybag_is_ready'))
				end

				BagContour:SetScene()
			end

		else
			for i in ipairs(BagContour.examples) do
				if alive(BagContour._bags[i]) then
					World:delete_unit(BagContour._bags[i])
				end
				BagContour._bags[i] = nil
			end
			if alive(BagContour._bodybag) then
				World:delete_unit(BagContour._bodybag)
			end
			BagContour._bodybag = nil
			BagContour:RemoveWeightLabels()

			if BagContour.lootbag_is_ready then
				managers.dyn_resource:unload(ids_unit, ids_lootbag_name, drp)
				BagContour.lootbag_is_ready = nil
			end
			if BagContour.bodybag_is_ready then
				managers.dyn_resource:unload(ids_unit, ids_bodybag_name, drp)
				BagContour.bodybag_is_ready = nil
			end
		end
	end

	local function _BagContourSetColor()
		local menu = MenuHelper:GetMenu('bc_options_menu')

		for _, x in pairs({'L', 'H', 'B'}) do
			local r, g, b = CoreMath.hsv_to_rgb(
				menu:item(x .. 'H'):value(),
				menu:item(x .. 'S'):value(),
				menu:item(x .. 'V'):value()
			)
			BagContour.settings[x .. 'R'] = r / 100
			BagContour.settings[x .. 'G'] = g / 100
			BagContour.settings[x .. 'B'] = b / 100
		end

		BagContour:UpdateColors()
	end

	MenuCallbackHandler.BagContourSetColor = function(this, item)
		_BagContourSetColor()
	end

	MenuCallbackHandler.BagContourCustomBags = function(this, item)
		managers.menu:open_node(BagContour._custom_colors_menu_id)
	end

	MenuCallbackHandler.BagContourCustomizeHub = function(this, item)
		BagContour._customizing_carry_id = item:name()
		managers.menu:open_node(BagContour._customize_color_menu_id)
	end

	MenuCallbackHandler.BagContourReset = function(this, item)
		BagContour:Reset()
		BagContour:InitWeightSliders()
		_BagContourSetColor()
	end

	MenuCallbackHandler.BagContourSave = function(this, item)
		BagContour:Save()
	end

	BagContour:Load()
	BagContour:UpdateOverrides()
	BagContour:SetContourColors()
	MenuHelper:LoadFromJsonFile(BagContour._path .. 'menu/options.txt', BagContour, BagContour.settings)
	MenuHelper:LoadFromJsonFile(BagContour._path .. 'menu/custom.txt', BagContour)
end)

BagContourCreator = BagContourCreator or class()
function BagContourCreator.modify_node(node)
	node:clean_items()
	BagContour:UpdateOverrides()

	local function _populate(customized)
		local ordered = {}
		for carry_id, carry_data in pairs(tweak_data.carry) do
			if carry_data.type and carry_data.type ~= 'being' then
				if (not not BagContour._overrides[carry_id]) == customized then
					table.insert(ordered, {
						carry_id = carry_id,
						carry_data = carry_data,
						txt = managers.localization:text(carry_data.name_id):lower()
					})
				end
			end
		end
		table.sort(ordered, function(a, b) return a.txt < b.txt end)

		for _, carry in pairs(ordered) do
			local params = {
				name = carry.carry_id,
				text_id = carry.carry_data.name_id,
				callback = 'BagContourCustomizeHub',
				to_upper = false,
				help_id = carry.carry_id .. ' (' .. carry.carry_data.type .. ')',
				localize = true,
				localize_help = false
			}
			local new_item = node:create_item(nil, params)
			node:add_item(new_item)
		end
	end

	_populate(true)
	node:add_item(node:create_item({type = 'MenuItemDivider'}, {size = 16, no_text = true}))
	_populate(false)

	managers.menu:add_back_button(node)
	return node
end
