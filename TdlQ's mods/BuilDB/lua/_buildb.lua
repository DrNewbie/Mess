_G.BuilDB = _G.BuilDB or {}
BuilDB._path = ModPath
BuilDB._db_path = SavePath .. 'buildb_builds.txt'
BuilDB._data_path = SavePath .. 'buildb_settings.txt'
BuilDB._import_menu_id = 'buildb_import'
BuilDB._url_formats = {}
BuilDB.settings = {
	export_format = 'invalid',
	text_editor = '%windir%\\system32\\notepad.exe',
}

function BuilDB:RegisterUrlFormat(cls, set_as_default)
	if type(cls) == 'table' and cls._tag then
		self._url_formats[cls._tag] = cls
		if set_as_default then
			self.settings.export_format = cls._tag
		end
	end
end

function BuilDB:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()

		for tag, cls in pairs(self._url_formats) do
			local url_override = self.settings['url_' .. tag]
			if url_override then
				cls:SetUrl(url_override)
			end
		end
	end
end

function BuilDB:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function BuilDB:Setup()
	self.fmt = self._url_formats[self.settings.export_format] or self._url_formats['pd2builder']
end

function BuilDB:GetBuildUrl()
	return self.fmt and self.fmt:GetBuildUrl()
end

function BuilDB:Import(url)
	for tag, cls in pairs(self._url_formats) do
		if url:find(tag) then
			return cls:Import(url)
		end
	end

	return false, 'unknown url type'
end

function BuilDB:CheckDB()
	if not io.file_is_readable(self._db_path) then
		local fh = io.open(self._db_path, 'w')
		if not fh then
			return false
		end
		fh:write(string.char(239, 187, 191))
		fh:write('# Keep the UTF-8 encoding of this file or some characters may not appear correctly in the game.\n')
		fh:write('# Only the lines matching the format "URL + 1 tabulation + build description" will be listed in the import menu.\n\n')
		fh:write('https://pd2builder.netlify.com/?s=d0-7410-4100100d0-710	Example\n')
		fh:write('You can describe your build more precisely without interfering with the menu.\n')
		fh:write('Only the first 2 lines following a build link are displayed (above the list).\n')
		fh:write('So this line won\'t appear.\n')
		fh:close()
	end
	return true
end

function BuilDB:LoadDB()
	self.builds = {}
	if self:CheckDB() then
		local ldesc = {}
		for line in io.lines(self._db_path) do
			local url, title = line:match('^(https?://.*)	(.*)$')
			if url then
				if #ldesc > 0 and #self.builds > 0 then
					self.builds[#self.builds].desc = table.concat(ldesc, '\n')
				end
				ldesc = {}
				table.insert(self.builds, { url = url, title = title, desc = '' })
			else
				if #ldesc < 2 then
					table.insert(ldesc, line)
				end
			end
		end
		if #ldesc > 0 and #self.builds > 0 then
			self.builds[#self.builds].desc = table.concat(ldesc, '\n')
		end
	end
end

function BuilDB:LookAtBuild()
	local build = BuilDB.builds[BuilDB._build_id_to_import]
	Steam:overlay_activate('url', build.url)
end

MenuCallbackHandler.BuilDBHandleHub = function(this, item)
	BuilDB._build_id_to_import = 10000 - item._priority
	local title = managers.localization:text('dialog_skills_respec_title')
	local message = managers.localization:text('buildb_dialog_import_message')
	local menu_options = {
		[1] = {
			text = managers.localization:text('dialog_apply'),
			callback = BuilDB.ImportClbk,
		},
		[2] = {
			text = managers.localization:text('buildb_dialog_import_btn_preview'),
			callback = BuilDB.LookAtBuild,
		},
		[3] = {
			text = managers.localization:text('dialog_cancel'),
			is_cancel_button = true,
		},
	}
	QuickMenu:new(title, message, menu_options, true)
end

function BuilDB:GenerateMenu(node)
	self:LoadDB()

	for i, build in ipairs(self.builds) do
		local params = {
			name = 'button_buildb_import-' .. tostring(i),
			text_id = build.title,
			callback = 'BuilDBHandleHub',
			to_upper = false,
			help_id = build.desc,
			localize = false,
			localize_help = false
		}
		local new_item = node:create_item(nil, params)
		new_item._priority = 10000 - i
		node:add_item(new_item)
	end
end

_G.BuilDBCreator = _G.BuilDBCreator or class()
function BuilDBCreator.modify_node(node)
	node:clean_items()
	BuilDB:GenerateMenu(node)
	managers.menu:add_back_button(node)
	return node
end

function BuilDB:ShowMenu()
	managers.menu:open_node(self._import_menu_id, {})
	managers.menu:active_menu().renderer.ws:show()
end

function BuilDB:ImportClbk()
	managers.menu:back(true)
	local build = BuilDB.builds[BuilDB._build_id_to_import]
	log('[BuilDB] Old: ' .. BuilDB:GetBuildUrl())
	log('[BuilDB] New: ' .. build.url)
	local ok, tip = BuilDB:Import(build.url)
	if not ok then
		local title = managers.localization:text('dialog_error_title')
		local message = string.format('%s (%s)', managers.localization:text('error'), tip)
		QuickMenu:new(title, message, {}, true)
	end
end

function BuilDB:GetCurrentBuildMainRole()
	local ppb = {}
	local ppt = {}
	for tree, tree_data in ipairs(tweak_data.skilltree.trees) do
		local points_spent = managers.skilltree:points_spent(tree)
		local b = math.floor((tree - 1) / 3) + 1
		ppb[b] = (ppb[b] or 0) + points_spent
		table.insert(ppt, {points_spent, managers.localization:text(tree_data.name_id)})
	end

	local roles = {'st_menu_mastermind', 'st_menu_enforcer', 'st_menu_technician', 'st_menu_ghost', 'st_menu_hoxton_pack', 'menu_loadout_empty'}
	local m = -1
	local r = 6
	for k, v in pairs(ppb) do
		if v > 0 and v > m then
			m = v
			r = k
		end
	end
	local role = managers.localization:text(roles[r])

	table.sort(ppt, function(a, b) return a[1] > b[1] end)
	local descr_tbl = {}
	for i = 1, #ppt do
		if ppt[i][1] > 20 then
			table.insert(descr_tbl, string.format('%s (%i)', ppt[i][2], ppt[i][1]))
		end
	end
	local descr = table.concat(descr_tbl, ', ')

	return role, descr
end

function BuilDB:SaveCurrentBuild()
	local current_specialization = managers.skilltree:digest_value(Global.skilltree_manager.specializations.current_specialization, false, 1)	
	local spec_text = managers.localization:text('menu_st_spec_' .. current_specialization)
	local role, descr = self:GetCurrentBuildMainRole()

	local save_text = string.format('\n\n%s	%s %s\n%s\n', self:GetBuildUrl(), spec_text, role, descr)

	local fh = io.open(self._db_path, 'a')
	if fh then
		fh:write(save_text)
		fh:close()
	end
end

dofile(ModPath .. 'lua/_pd2skills.lua')
dofile(ModPath .. 'lua/_pd2builder.lua')

BuilDB:Setup()
BuilDB:Load()
BuilDB:Save()
