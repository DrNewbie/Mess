if not BuilDB then
	dofile(ModPath .. 'lua/_buildb.lua')
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_BuilDB', function(loc)
	local language_filename

	local modname_to_language = {
		['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
	}
	for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
		language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
		if language_filename then
			break
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(BuilDB._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(BuilDB._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(BuilDB._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerSetupCustomMenus', 'MenuManagerSetupCustomMenus_BuilDB', function(menu_manager, nodes)
	MenuHelper:NewMenu(BuilDB._import_menu_id)
end)

MenuCallbackHandler.BuilDBChangedFocus = function(node, focus)
	if managers and managers.menu_component then
		local sg = managers.menu_component._skilltree_gui
		if not sg then
			return
		end

		if focus then
			sg._enabled = false

			sg._panel:set_alpha(0.4)
			sg._panel:child('BackButton'):set_visible(false)
			sg._panel:child('InfoRootPanel'):set_visible(false)
			sg._panel:child('LegendsPanel'):set_visible(false)

			sg._bdb_blur_panel = sg._bdb_blur_panel or sg._fullscreen_ws:panel():panel({layer = 50})				
			sg._bdb_blur = sg._bdb_blur or sg._bdb_blur_panel:bitmap({
				texture = 'guis/textures/test_blur_df',
				w = sg._fullscreen_ws:panel():w(),
				h = sg._fullscreen_ws:panel():h(),
				render_template = 'VertexColorTexturedBlur3D'
			})
			sg._bdb_blur_panel:set_visible(true)

			sg._buildb_mask = sg._buildb_mask or sg._fullscreen_panel:rect({
				color = Color(0.7, 0, 0, 0),
				layer = 0,
				halign = 'grow',
				valign = 'grow'
			})
			sg._buildb_mask:set_visible(true)

		else
			sg._enabled = true
			sg._buildb_mask:set_visible(false)
			sg._bdb_blur_panel:remove(sg._bdb_blur)
			sg._bdb_blur = nil
			sg._bdb_blur_panel:parent():remove(sg._bdb_blur_panel)
			sg._bdb_blur_panel = nil
		end
	end
end

Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_BuilDB', function(menu_manager, nodes)
	nodes[BuilDB._import_menu_id] = MenuHelper:BuildMenu(BuilDB._import_menu_id, {})
	nodes[BuilDB._import_menu_id]:parameters().modifier = {BuilDBCreator.modify_node}
	nodes[BuilDB._import_menu_id]:parameters().focus_changed_callback = {MenuCallbackHandler.BuilDBChangedFocus}
end)
