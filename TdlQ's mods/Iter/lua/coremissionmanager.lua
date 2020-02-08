local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.Iter = _G.Iter or {}
Iter._path = ModPath
Iter._data_path = SavePath .. 'iter.txt'
Iter.settings = {
	streamline_path = true,
	map_change_alex_1 = true,
	map_change_alex_2 = true,
	map_change_arena = true,
	map_change_arm_for = true,
	map_change_big = true,
	map_change_born = true,
	map_change_branchbank = true,
	map_change_brb = true,
	map_change_cane = true,
	map_change_chew = true,
	map_change_chill_combat = true,
	map_change_crojob2 = true,
	map_change_dah = true,
	map_change_dinner = true,
	map_change_escape_garage = true,
	map_change_family = true,
	map_change_firestarter_1 = true,
	map_change_firestarter_3 = true,
	map_change_flat = true,
	map_change_framing_frame_1 = true,
	map_change_friend = true,
	map_change_gallery = true,
	map_change_glace = true,
	map_change_jewelry_store = true,
	map_change_jolly = true,
	map_change_kenaz = true,
	map_change_kosugi = true,
	map_change_mad = true,
	map_change_mex = true,
	map_change_mia_1 = true,
	map_change_moon = true,
	map_change_mus = true,
	map_change_pbr = true,
	map_change_pbr2 = true,
	map_change_peta = true,
	map_change_pines = true,
	map_change_rat = true,
	map_change_red2 = true,
	map_change_roberts = true,
	map_change_rvd1 = true,
	map_change_vit = true,
	map_change_watchdogs_1 = true,
	map_change_welcome_to_the_jungle_2 = true,
	map_change_wwh = true
}

function Iter:load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function Iter:save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function Iter:get_level_id()
	local level_id = Global.game_settings and Global.game_settings.level_id or ''
	level_id = level_id:gsub('_night$', ''):gsub('_day$', '')
	return level_id
end

Iter:load()

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_Iter', function(loc)
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
		for _, filename in pairs(file.GetFiles(Iter._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(Iter._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(Iter._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_Iter', function(menu_manager)

	MenuCallbackHandler.IterMenuCheckboxClbk = function(this, item)
		Iter.settings[item:name()] = item:value() == 'on'
	end

	MenuCallbackHandler.IterSave = function(this, item)
		Iter:save()
	end

	MenuHelper:LoadFromJsonFile(Iter._path .. 'menu/options.txt', Iter, Iter.settings)

	Hooks:Add('MenuManagerBuildCustomMenus', 'MenuManagerBuildCustomMenus_Iter', function(menu_manager, nodes)
		nodes.itr_options_menu:parameters().modifier = {IterMenuCreator.modify_node}
	end)

end)

IterMenuCreator = IterMenuCreator or class()
function IterMenuCreator.modify_node(node)
	local old_items = node:items()
	node:clean_items()
	for i = 1, 2 do
		node:add_item(table.remove(old_items, 1))
	end
	table.sort(old_items, function(a, b)
		local a = managers.localization:text(a:parameters().text_id)
		local b = managers.localization:text(b:parameters().text_id)
		return a < b
	end)
	for _, item in pairs(old_items) do
		node:add_item(item)
	end
	return node
end

core:module('CoreMissionManager')
core:import('CoreTable')

local itr_custom_elements = {}

if Network:is_client() then
	function MissionScript:load(data)
		local state = data[self._name]
		if data.iter then
			for id, element in pairs(data.iter) do
				state[id] = element
			end
			data.iter = nil
		end

		if self._element_groups.ElementInstancePoint then
			for _, element in ipairs(self._element_groups.ElementInstancePoint) do
				local id = element:id()
				if state[id] then
					self._elements[id]:load(state[id])
					state[id] = nil
				end
			end
		end

		for id, mission_state in pairs(state) do
			-- there can be uninitialized elements when host doesn't use Iter
			local element = self._elements[id]
			if element and type(element.load) == 'function' then
				element:load(mission_state)
			end
		end
	end
else
	local itr_original_missionscript_save = MissionScript.save
	function MissionScript:save(data)
		itr_original_missionscript_save(self, data)

		local state = data[self._name]
		local itr_state = {}
		for _, id in ipairs(itr_custom_elements) do
			itr_state[id] = state[id]
			state[id] = nil
		end
		data.iter = itr_state
	end
end

local level_id = _G.Iter:get_level_id()
local itr_original_missionmanager_addscript = MissionManager._add_script
local itr_original_missionscript_createelements = MissionScript._create_elements

if not _G.Iter.settings['map_change_' .. level_id] then
	-- qued

elseif level_id == 'kosugi' then

	function MissionScript:_create_elements(elements)
		table.insert(itr_custom_elements, 105000)

		for _, element in pairs(elements) do
			if element.id == 102617 then
				table.insert(element.values.on_executed, { delay = 0, id = 105000 })
			elseif element.id == 102626 then
				table.insert(element.values.on_executed, { delay = 0, id = 105000 })
				local element105000 = {
					id = 105000,
					module = 'CoreElementToggle',
					editor_name = 'itr_toggle_SO',
					class = 'ElementToggle',
					values = {
						enabled = true,
						on_executed = {},
						elements = {
							103543,
							103545
						},
						set_trigger_times = -1,
						execute_on_startup = false,
						trigger_times = 0,
						toggle = 'on',
						base_delay = 0
					}
				}
				table.insert(elements, element105000)
			elseif element.id == 103543 or element.id == 103545 then
				element.values.enabled = false
			end
		end

		return itr_original_missionscript_createelements(self, elements)
	end

elseif level_id == 'cane' then

	function MissionScript:_create_elements(elements)
		for _, element in pairs(elements) do
			if element.id == 136356 then
				element.values.on_executed[1].id = 136446
			end
		end

		return itr_original_missionscript_createelements(self, elements)
	end

elseif level_id == 'friend' then

	function MissionManager:_add_script(data)
		table.insert(itr_custom_elements, 105000)
		table.insert(itr_custom_elements, 105001)

		for _, element in pairs(data.elements) do
			if element.id == 103880 then
				table.insert(element.values.on_executed, { delay = 0, id = 105000 })
			elseif element.id == 103877 then
				table.insert(element.values.on_executed, { delay = 0, id = 105001 })
				local element105000 = {
					id = 105000,
					class = 'ElementAINavSeg',
					values = {
						enabled = true,
						operation = 'remove_nav_seg_neighbours',
						base_delay = 0,
						on_executed = {},
						execute_on_startup = false,
						trigger_times = 0,
						segment_ids = { 106, 55, 55, 106 }
					},
					editor_name = 'itr_remove_link1'
				}
				table.insert(data.elements, element105000)

				local element105001 = CoreTable.deep_clone(element105000)
				element105001.id = 105001
				element105001.values.segment_ids = { 71, 55, 55, 71 }
				element105001.editor_name = 'itr_remove_link2'
				table.insert(data.elements, element105001)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'rat' or level_id == 'alex_1' then

	function MissionManager:_add_script(data)
		table.insert(itr_custom_elements, 102659)
		table.insert(itr_custom_elements, 102660)

		for _, element in pairs(data.elements) do
			if element.editor_name == 'playersEnteredSniperPosition' then
				table.insert(element.values.on_executed, { delay = 0, id = 102659 })
				table.insert(element.values.on_executed, { delay = 0, id = 102660 })
			elseif element.editor_name == 'SO_teammate_shortcut007' then
				local roof_down = CoreTable.deep_clone(element)
				roof_down.editor_name = 'itr_SO_teammate_shortcut_roof_down'
				roof_down.id = 102659
				roof_down.values.so_action = 'e_nl_dwn_3_75m'
				roof_down.values.position = Vector3(2235, 973, 2097)
				roof_down.values.rotation = Rotation(-90, 0, 0)
				roof_down.values.search_position = Vector3(2395, 595, 1718)
				roof_down.values.interval = 2
				table.insert(data.elements, roof_down)
			elseif element.editor_name == 'SO_shortcut013' then
				local roof_up = CoreTable.deep_clone(element)
				roof_up.editor_name = 'itr_SO_teammate_shortcut_roof_up'
				roof_up.id = 102660
				roof_up.values.position = Vector3(2455, 800, 1726)
				roof_up.values.search_position = Vector3(2200, 800, 2100.55)
				roof_up.values.rotation = Rotation(90, -0, -0)
				roof_up.values.path_haste = 'none'
				roof_up.values.so_action = 'e_nl_ladder_up_3m'
				roof_up.values.interval = 2
				table.insert(data.elements, roof_up)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'jolly' then

	function MissionManager:_add_script(data)
		local base_element_id = 101785
		table.insert(itr_custom_elements, base_element_id)
		table.insert(itr_custom_elements, base_element_id + 1)
		table.insert(itr_custom_elements, base_element_id + 2)
		table.insert(itr_custom_elements, base_element_id + 3)

		for _, element in pairs(data.elements) do
			if element.id == 100760 or element.id == 100761 or element.id == 100762 or element.id == 100763
			or element.id == 100766 or element.id == 100767 or element.id == 100768 or element.id == 100769
			then
				element.values.SO_access = '16383'

			elseif element.id == 100406 then
				table.remove(element.values.on_executed, 308)
				table.insert(element.values.on_executed, { delay = 0, id = base_element_id })
				table.insert(element.values.on_executed, { delay = 0, id = base_element_id + 1 })
				table.insert(element.values.on_executed, { delay = 0, id = base_element_id + 2 })
				table.insert(element.values.on_executed, { delay = 0, id = base_element_id + 3 })

			elseif element.id == 101124 then
				element.values.repeatable = true
				element.values.so_action = 'e_nl_down_1m'
				element.values.align_position = false
				element.values.rotation = Rotation(103, 0, 0)
				element.values.position = Vector3(4686, 2490, 92)
				element.values.search_position = Vector3(4553, 2456, -1)
			elseif element.id == 100544 then
				local ladder1 = CoreTable.deep_clone(element)
				ladder1.editor_name = 'itr_SO_AI_ladder1'
				ladder1.id = base_element_id
				ladder1.values.align_position = true
				ladder1.values.attitude = 'avoid'
				ladder1.values.interval = 1.5
				ladder1.values.repeatable = true
				ladder1.values.so_action = 'e_nl_up_6m_var3'
				ladder1.values.path_style = 'destination'
				ladder1.values.rotation = Rotation(-150, 0, 0)
				ladder1.values.position = Vector3(-1533, 6530, 607)
				ladder1.values.search_position = Vector3(-1547, 6260, 1212)
				table.insert(data.elements, ladder1)

				local ladder2 = CoreTable.deep_clone(ladder1)
				ladder2.editor_name = 'itr_SO_AI_ladder2'
				ladder2.id = base_element_id + 1
				ladder2.values.rotation = Rotation(0, 0, 0)
				ladder2.values.position = Vector3(-1583, -325, 607)
				ladder2.values.search_position = Vector3(-1538, -80, 1212)
				table.insert(data.elements, ladder2)

				local ladder3 = CoreTable.deep_clone(ladder1)
				ladder3.editor_name = 'itr_SO_AI_ladder3'
				ladder3.id = base_element_id + 2
				ladder3.values.so_action = 'e_nl_cs_up_8m_ladder'
				ladder3.values.rotation = Rotation(180, 0, 0)
				ladder3.values.position = Vector3(2353, 6485, 300)
				ladder3.values.search_position = Vector3(2352, 6262, 1213)
				table.insert(data.elements, ladder3)

				local ladder4 = CoreTable.deep_clone(ladder3)
				ladder4.editor_name = 'itr_SO_AI_ladder4'
				ladder4.id = base_element_id + 3
				ladder4.values.rotation = Rotation(0, 0, 0)
				ladder4.values.position = Vector3(2364, -315, 300)
				ladder4.values.search_position = Vector3(2360, -118, 1217)
				table.insert(data.elements, ladder4)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'moon' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 104665 then
				for i = 1, 5 do
					table.remove(element.values.on_executed, 1)
				end
			elseif element.id == 101144 then
				element.values.search_position = Vector3(490, -1258, 400)
			elseif element.id == 101445 then
				element.values.search_position = Vector3(490, -1258, 400)
			elseif element.id == 103774 then
				element.values.search_position = Vector3(62, -1232, 400)
			elseif element.id == 103775 then
				element.values.search_position = Vector3(62, -1232, 400)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'peta' then

	function MissionManager:_add_script(data)

		for _, element in pairs(data.elements) do
			if element.id == 100479 then
				table.remove(element.values.obstacle_list, 7)
			elseif element.id == 100245 then
				local ramp_id = 105000
				table.insert(data.elements, {
					id = ramp_id,
					editor_name = 'itr_patch_ramp',
					class = 'ElementChangeBodyProperty',
					values = {
						enabled = true,
						on_executed = {},
						things = {
							{ 100212, 14, 'set_fixed', true },
							{ 101390, 14, 'set_fixed', true },
							{ 101834, 14, 'set_fixed', true },
						},
						execute_on_startup = false,
						trigger_times = 1,
						toggle = 'on',
						base_delay = 0
					}
				})
				table.insert(itr_custom_elements, ramp_id)
				table.insert(element.values.on_executed, {id = ramp_id, delay = 5})
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'flat' then

	local function itr_mk_toggle(id, ...)
		table.insert(itr_custom_elements, id)

		local element = {
			id = id,
			module = 'CoreElementToggle',
			editor_name = 'itr_toggle_window_trigger_area_' .. id,
			class = 'ElementToggle',
			values = {
				enabled = true,
				on_executed = {},
				elements = { ... },
				execute_on_startup = false,
				trigger_times = 1,
				toggle = 'on',
				base_delay = 0
			}
		}
		return element
	end

	local function itr_mk_trigger(id, so_id, toggle_id, pos)
		table.insert(itr_custom_elements, id)

		local element = {
			id = id,
			editor_name = 'itr_SO_trigger_window_toggle_' .. id,
			class = 'ElementSpecialObjectiveTrigger',
			values = {
				enabled = true,
				on_executed = {
					{ delay = 0, id = toggle_id }
				},
				elements = { so_id },
				event = 'anim_act_04',
				execute_on_startup = false,
				trigger_times = 1,
				base_delay = 0,
				position = pos,
				rotation = Rotation(0, 0, -0)
			}
		}
		return element
	end

	local window_to_SO = {
		[100031] = 101063,
		[100047] = 101257,
		-- [100063] = ?,
		-- [102237] = ?,
		[102326] = 102141,
		[102327] = 100352,
		[102609] = 103253,
		[103282] = 102200,
		-- [103399] = ?,
		-- [103420] = ?,
	}
	function MissionManager:_add_script(data)
		local insert_id = 105000
		local SOs = {}
		for _, element in pairs(data.elements) do
			if element.id == 104122 then
				table.insert(element.values.elements, 104832)

			elseif element.id == 104150 then
				table.insert(element.values.elements, 104833)

			elseif element.editor_name:find('check enemy touch window') then
				element.values.enabled = false
				local so_id = window_to_SO[element.id]
				if so_id then
					SOs[so_id] = true
					table.insert(data.elements, itr_mk_toggle(insert_id, element.id))
					table.insert(data.elements, itr_mk_trigger(insert_id + 1, window_to_SO[element.id], insert_id, element.values.position))
					insert_id = insert_id + 2
				end
			end
		end
		for _, element in pairs(data.elements) do
			if SOs[element.id] then
				element.values.scan = true
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'arena' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 102016 or element.id == 102090 then
				element.values.enabled = false
			elseif element.id == 101004 then
				element.values.search_position = Vector3(-3423, -108, 800)
			elseif element.id == 101331 then
				element.values.search_position = Vector3(-342.589, 293.87, 0)
			elseif element.id == 101332 then
				element.values.search_position = Vector3(300, 295, 0)
			elseif element.id == 101333 then
				element.values.search_position = Vector3(300, 295, 0)
			elseif element.id == 101662 then
				element.values.search_position = Vector3(570, 1528, 0)
			elseif element.id == 101665 then
				element.values.search_position = Vector3(570, 1425, 0)
			elseif element.id == 101677 then
				element.values.search_position = Vector3(570, 1715, 0)
			elseif element.id == 102756 then
				element.values.search_position = Vector3(570, 1425, 0)
			elseif element.id == 102757 then
				element.values.search_position = Vector3(570, 1715, 0)
			elseif element.id == 102758 then
				element.values.search_position = Vector3(275, 1650, 0)
			elseif element.id == 102759 then
				element.values.search_position = Vector3(288, 1528, 0)
			elseif element.id == 102767 then
				element.values.search_position = Vector3(54, 1247, 0)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'red2' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 102449 then
				element.values.position = Vector3(-55, 1905, -25)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'pbr2' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 100063 then
				table.remove(element.values.on_executed, 2)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'gallery' or level_id == 'framing_frame_1' then

	function MissionManager:_add_script(data)
		for i = 105000, 105012 do
			table.insert(itr_custom_elements, i)
		end

		local id_navseg_allow_access = 105000
		local id_navseg_forbid_access = 105001
		local id_navlink_window1_in = 105002
		local id_navlink_window1_out = 105003
		local id_navlink_window1_out_bis = 105004
		local id_navlink_window2_out = 105005
		local id_navlink_window2_out_bis = 105006
		local id_toggle_window1 = 105007
		local id_toggle_window2 = 105008
		local id_seq_destroy_window1 = 105009
		local id_seq_destroy_window2 = 105010
		local id_trigger_destroy_window1 = 105011
		local id_trigger_destroy_window2 = 105012

		local navseg_allow_access = {
			id = id_navseg_allow_access,
			class = 'ElementAIGraph',
			editor_name = 'itr_navseg_allow_100',
			values = {
				execute_on_startup = false,
				operation = 'allow_access',
				graph_ids = { 100 },
				base_delay = 0,
				trigger_times = 0,
				on_executed = {},
				enabled = true,
			}
		}
		table.insert(data.elements, navseg_allow_access)

		local navseg_forbid_access = CoreTable.deep_clone(navseg_allow_access)
		navseg_forbid_access.id = id_navseg_forbid_access
		navseg_forbid_access.editor_name = 'itr_navseg_forbid_100'
		navseg_forbid_access.values.operation = 'forbid_access'
		table.insert(data.elements, navseg_forbid_access)

		local navlink_window1_in = {
			id = id_navlink_window1_in,
			class = 'ElementSpecialObjective',
			editor_name = 'itr_navlink_window1_in',
			values = {
				on_executed = {},
				align_position = true,
				ai_group = 'enemies',
				is_navigation_link = true,
				position = Vector3(2139, 860, -98),
				scan = true,
				needs_pos_rsrv = true,
				enabled = true,
				execute_on_startup = false,
				rotation = Rotation(180, 0, 0),
				base_delay = 0,
				action_duration_min = 0,
				search_position = Vector3(2139, 743, 1.5),
				use_instigator = false,
				trigger_times = 0,
				trigger_on = 'none',
				so_action = 'e_nl_up_1m',
				search_distance = 0,
				interval = 1,
				path_stance = 'none',
				path_haste = 'none',
				repeatable = false,
				attitude = 'avoid',
				action_duration_max = 0,
				no_arrest = false,
				chance_inc = 0,
				pose = none,
				forced = false,
				base_chance = 1,
				interaction_voice = 'none',
				SO_access = '245760',
				interrupt_dmg = 0,
				align_rotation = true,
				interrupt_objective = true,
				interrupt_dis = 0,
				path_style = 'destination',
				patrol_path = 'none',
			}
		}
		table.insert(data.elements, navlink_window1_in)

		local navlink_window2_out = CoreTable.deep_clone(navlink_window1_in)
		navlink_window2_out.id = id_navlink_window2_out
		navlink_window2_out.editor_name = 'itr_navlink_window2_out'
		navlink_window2_out.values.so_action = 'e_nl_jump_dwn_1_4m_fwd_2_35m'
		navlink_window2_out.values.position = Vector3(2103, -739, 1.5)
		navlink_window2_out.values.search_position = Vector3(2064, -1072, -120)
		table.insert(data.elements, navlink_window2_out)

		local navlink_window2_out_bis = CoreTable.deep_clone(navlink_window2_out)
		navlink_window2_out_bis.id = id_navlink_window2_out_bis
		navlink_window2_out_bis.editor_name = 'itr_navlink_window2_out_bis'
		navlink_window2_out_bis.values.so_action = 'e_nl_down_1m'
		navlink_window2_out_bis.values.position = Vector3(2103, -739, 1.5)
		navlink_window2_out_bis.values.search_position = Vector3(2064, -1072, -120)
		table.insert(data.elements, navlink_window2_out_bis)

		local navlink_window1_out = CoreTable.deep_clone(navlink_window2_out)
		navlink_window1_out.id = id_navlink_window1_out
		navlink_window1_out.editor_name = 'itr_navlink_window1_out'
		navlink_window1_out.values.rotation = Rotation(0, 0, 0)
		navlink_window1_out.values.position = Vector3(2139, 743, 1.5)
		navlink_window1_out.values.search_position = Vector3(2139, 1070, -98)
		table.insert(data.elements, navlink_window1_out)

		local navlink_window1_out_bis = CoreTable.deep_clone(navlink_window2_out_bis)
		navlink_window1_out_bis.id = id_navlink_window1_out_bis
		navlink_window1_out_bis.editor_name = 'itr_navlink_window1_out_bis'
		navlink_window1_out_bis.values.rotation = Rotation(0, 0, 0)
		navlink_window1_out_bis.values.position = Vector3(2139, 743, 1.5)
		navlink_window1_out_bis.values.search_position = Vector3(2139, 860, -98)
		table.insert(data.elements, navlink_window1_out_bis)

		local seq_destroy_window1 = {
			id = id_seq_destroy_window1,
			class = 'ElementUnitSequence',
			module = 'CoreElementUnitSequence',
			editor_name = 'itr_seq_destroy_window1',
			values = {
				position = Vector3(),
				execute_on_startup = false,
				trigger_times = 0,
				trigger_list = {
					{
						id = 1,
						time = 0,
						notify_unit_id = 100378,
						name = 'run_sequence',
						notify_unit_sequence = 'seq_damage_window'
					},
					{
						id = 2,
						time = 0,
						notify_unit_id = 100378,
						name = 'run_sequence',
						notify_unit_sequence = 'seq_break_window'
					}
				},
				enabled = true,
				base_delay = 0,
				on_executed = {
					{ delay = 0, id = id_navlink_window1_out_bis },
					{ delay = 0, id = id_toggle_window1 }
				}
			}
		}
		table.insert(data.elements, seq_destroy_window1)

		local trigger_destroy_window1 = {
			id = id_trigger_destroy_window1,
			class = 'ElementSpecialObjectiveTrigger',
			editor_name = 'itr_trigger_destroy_window1',
			values = {
				execute_on_startup = false,
				base_delay = 0,
				elements = {
					id_navlink_window1_in,
					id_navlink_window1_out
				},
				event = 'anim_act_04',
				enabled = true,
				trigger_times = 1,
				on_executed = {
					{ delay = 0, id = id_seq_destroy_window1 }
				}
			}
		}
		table.insert(data.elements, trigger_destroy_window1)

		local seq_destroy_window2 = CoreTable.deep_clone(seq_destroy_window1)
		seq_destroy_window2.id = id_seq_destroy_window2
		seq_destroy_window2.editor_name = 'itr_seq_destroy_window2'
		seq_destroy_window2.values.trigger_list[1].notify_unit_id = 100275
		seq_destroy_window2.values.trigger_list[2].notify_unit_id = 100275
		seq_destroy_window2.values.on_executed[1].id = id_navlink_window2_out_bis
		seq_destroy_window2.values.on_executed[2].id = id_toggle_window2
		table.insert(data.elements, seq_destroy_window2)

		local trigger_destroy_window2 = CoreTable.deep_clone(trigger_destroy_window1)
		trigger_destroy_window2.id = id_trigger_destroy_window2
		trigger_destroy_window2.editor_name = 'itr_trigger_destroy_window2'
		trigger_destroy_window2.values.elements = { id_navlink_window2_out }
		trigger_destroy_window2.values.on_executed = {
			{ delay = 0, id = id_seq_destroy_window2 }
		}
		table.insert(data.elements, trigger_destroy_window2)

		local toggle_window1 = {
			id = id_toggle_window1,
			class = 'ElementToggle',
			module = 'CoreElementToggle',
			editor_name = 'itr_toggle_window1',
			values = {
				execute_on_startup = false,
				trigger_times = 1,
				enabled = true,
				on_executed = {},
				base_delay = 0,
				elements = {
					id_navlink_window1_out
				},
				set_trigger_times = -1
			}
		}
		table.insert(data.elements, toggle_window1)

		local toggle_window2 = CoreTable.deep_clone(toggle_window1)
		toggle_window2.id = id_toggle_window2
		toggle_window2.editor_name = 'itr_toggle_window2'
		toggle_window2.values.elements = {
			id_navlink_window2_out
		}
		table.insert(data.elements, toggle_window2)

		for _, element in pairs(data.elements) do
			if element.id == 103576 then
				element.values.position = Vector3(2500, -95, 0)
			elseif element.id == 103570 or element.id == 103571 then
				table.insert(element.values.on_executed, { delay = 0, id = id_navseg_allow_access })
			elseif element.id == 100435 then
				table.insert(element.values.on_executed, { delay = 0, id = id_navseg_forbid_access })
			elseif element.id == 103437 then
				table.insert(element.values.on_executed, { delay = 0, id = id_navlink_window1_in })
				table.insert(element.values.on_executed, { delay = 0, id = id_navlink_window1_out })
				table.insert(element.values.on_executed, { delay = 0, id = id_navlink_window2_out })
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'escape_garage' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 101654 or element.id == 103854 then
				local new_seq = CoreTable.deep_clone(element.values.sequence_list[1])
				new_seq.sequence = 'int_seq_saw_in'
				table.insert(element.values.sequence_list, new_seq)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'chill_combat' then

	_G.Iter.delete_instances = {
		['aldstone_001'] = true,
		['chill_bodhi_01_001'] = true,
		['chill_dragan_01_001'] = true,
		['chill_friend_001'] = true,
		['chill_hockey_game_001'] = true,
		['chill_jacket_01_001'] = true,
		['chill_punching_bag_001'] = true,
		['chill_sokol_01_001'] = true,
		['chill_vault_01_001'] = true,
		['chill_wick_kill_room_001'] = true,
		['chill_wick_target_dummy_01_001'] = true,
		['chill_wick_target_dummy_01_002'] = true,
		['chill_wick_target_dummy_01_003'] = true,
		['chill_wick_target_dummy_01_004'] = true,
		['chill_wick_target_dummy_01_005'] = true,
		['chill_wick_target_dummy_01_006'] = true,
		['chill_wick_target_dummy_01_007'] = true,
		['chill_wick_target_dummy_01_008'] = true,
		['chill_wick_target_dummy_01_009'] = true,
		['chill_wick_target_dummy_01_010'] = true,
		['chill_wick_target_dummy_01_011'] = true,
		['chill_wick_target_dummy_01_012'] = true,
		['chill_wick_target_dummy_01_013'] = true,
		['chill_wick_target_dummy_01_014'] = true,
		['chill_wick_target_dummy_01_015'] = true,
		['chill_wick_target_dummy_01_016'] = true,
		['chill_wolf_01_001'] = true,
		['max_001'] = true,
		['obj_link_002'] = true,
		['obj_link_003'] = true,
	}

	function MissionManager:_add_script(data)
		local instances = data.instances
		for i = #instances, 1, -1 do
			if _G.Iter.delete_instances[instances[i]] then
				table.remove(instances, i)
			end
		end

		for _, element in pairs(data.elements) do
			if element.class == 'ElementPlayerCharacterTrigger' then
				if element.values.trigger_on_left then
					element.values.enabled = false
				end
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'chew' then

	function MissionScript:_create_elements(elements)
		local ladder_nl = {
			[132229] = 154303,
			[132230] = 154304,
			[134229] = 154603,
			[134230] = 154604,
			[136229] = 154903,
			[136230] = 154904,
			[138229] = 155203,
			[138230] = 155204,
			[140229] = 155503,
			[140230] = 155504,
		}
		local navlink_to_move_a_bit = {
			[132417] = true,
			[132418] = true,
			[136417] = true,
			[136418] = true,
		}
		local d1 = Vector3(0, -30, 0)
		local d2 = Vector3(0, 5, 0)

		for _, element in pairs(elements) do
			if element.values.is_navigation_link and element.values.interval then
				element.values.interval = math.max(1, element.values.interval - 3)
				if element.editor_name:find('navlink_boxcar_through_hatch') == 1 then
					mvector3.add(element.values.search_position, d1)
				elseif element.editor_name:find('ladder_nl00') == 1 then
					mvector3.set_x(element.values.position, -1)
				end
			end

			if ladder_nl[element.id] then
				table.insert(element.values.on_executed, { delay = 0, id = ladder_nl[element.id]})

			elseif navlink_to_move_a_bit[element.id] then
				mvector3.add(element.values.position, d2)
			end

			if element.editor_name:find('navlink_boxcar_through_') == 1 then
				element.values.SO_access = '262140'
			end
		end

		return itr_original_missionscript_createelements(self, elements)
	end

elseif level_id == 'arm_for' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.values.is_navigation_link and element.values.interval == 6 then
				element.values.interval = 1
			elseif element.id == 102457 then
				table.insert(element.values.on_executed, { delay = 5, id = 100004 })
			elseif element.id == 102456 then
				table.insert(element.values.on_executed, { delay = 5, id = 100005 })
			elseif element.id == 102455 then
				table.insert(element.values.on_executed, { delay = 5, id = 100009 })
			elseif element.id == 102454 then
				table.insert(element.values.on_executed, { delay = 5, id = 100205 })
			elseif element.id == 102450 then
				table.insert(element.values.on_executed, { delay = 5, id = 100206 })
			elseif element.id == 102444 then
				table.insert(element.values.on_executed, { delay = 5, id = 100252 })
			elseif element.id == 105584 or element.id == 105587 then
				local new_seq = CoreTable.deep_clone(element.values.sequence_list[1])
				new_seq.sequence = 'int_seq_saw_in'
				table.insert(element.values.sequence_list, new_seq)

				new_seq = CoreTable.deep_clone(new_seq)
				new_seq.sequence = 'int_seq_explosion_in'
				table.insert(element.values.sequence_list, new_seq)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'mus' then

	function MissionManager:_add_script(data)
		table.insert(itr_custom_elements, 105000)

		local entrance_trigger = {
			id = 105000,
			class = 'ElementUnitSequenceTrigger',
			module = 'CoreElementUnitSequenceTrigger',
			editor_name = 'itr_entrance_trigger',
			values = {
				base_delay = 0,
				enabled = true,
				execute_on_startup = false,
				trigger_times = 1,
				sequence_list = {
					{ unit_id = 300022, guis_id = 1, sequence = 'done_opened' },
				},
				on_executed = {
					{ delay = 0, id = 101225 },
					{ delay = 0, id = 100796 },
					{ delay = 0, id = 100797 },
				},
			}
		}
		table.insert(data.elements, entrance_trigger)

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'kenaz' then

	function MissionScript:_create_elements(elements)
		for _, element in pairs(elements) do
			if element.id == 196574 then
				table.insert(element.values.on_executed, { delay = 0, id = 102887 })
			end
		end

		return itr_original_missionscript_createelements(self, elements)
	end

elseif level_id == 'glace' then

	function MissionManager:_add_script(data)
		local e102392, e102243
		for _, element in pairs(data.elements) do
			if element.id == 102392 then
				e102392 = element
			elseif element.id == 102243 then
				e102243 = element
			end
		end
		if e102392 and e102243 then
			e102243.values.trigger_list = CoreTable.deep_clone(e102392.values.trigger_list)
			e102243.values.trigger_list[1].notify_unit_id = 102519
			e102243.values.trigger_list[1].notify_unit_sequence = 'set_type_gold'
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'welcome_to_the_jungle_2' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 102507 then
				element.values.sequence_list[1].sequence = 'done_opened'
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'family' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 104059 then
				element.values.elements[1] = 101527
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'brb' then

	function MissionManager:_add_script(data)
		table.insert(itr_custom_elements, 103000)

		for _, element in pairs(data.elements) do
			if element.id == 100228 then
				table.insert(element.values.on_executed, { delay = 0, id = 103000 })
			elseif element.id == 100469 then
				table.remove(element.values.graph_ids, 3)

				local ai_graph = CoreTable.deep_clone(element)
				ai_graph.id = 103000
				ai_graph.values.graph_ids = { 44 }
				table.insert(data.elements, ai_graph)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'branchbank' or level_id == 'firestarter_3' then

	function MissionManager:_add_script(data)
		table.insert(itr_custom_elements, 106000)
		table.insert(itr_custom_elements, 106001)

		local element106000 = {
			id = 106000,
			class = 'ElementAINavSeg',
			editor_name = 'itr_add_link1',
			values = {
				enabled = true,
				operation = 'add_nav_seg_neighbours',
				base_delay = 0,
				on_executed = {},
				execute_on_startup = false,
				trigger_times = 0,
				segment_ids = { 92, 55, 55, 92 }
			}
		}
		table.insert(data.elements, element106000)

		local element106001 = CoreTable.deep_clone(element106000)
		element106001.id = 106001
		element106001.values.segment_ids = { 93, 56, 56, 93 }
		element106001.editor_name = 'itr_add_link2'
		table.insert(data.elements, element106001)

		for _, element in pairs(data.elements) do
			if element.id == 102160 then
				table.insert(element.values.on_executed, { delay = 0, id = 106000 })
			elseif element.id == 100311 then
				table.insert(element.values.on_executed, { delay = 0, id = 106001 })
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'rvd1' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 101436 then
				table.insert(element.values.sequence_list, { unit_id = 100072, guis_id = 1, sequence = 'int_seq_break' } )
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'big' then

	function MissionManager:_add_script(data)
		local outer = {
			[100535] = true,
			[100538] = true,
			[100540] = true,
			[100542] = true,
			[100544] = true,
			[100546] = true,
			[100548] = true,
			[100550] = true,
			[100552] = true,
			[100554] = true
		}
		for _, element in pairs(data.elements) do
			if outer[element.id] then
				element.values.on_executed[1] = { id = 102476, delay = 0 }
			elseif element.id == 106214 then
				local bus_id = 110000
				table.insert(data.elements, {
					id = bus_id,
					editor_name = 'itr_patch_bus',
					class = 'ElementChangeBodyProperty',
					values = {
						enabled = true,
						on_executed = {},
						things = {
							{ 105181, 2, 'set_fixed', true },
						},
						execute_on_startup = false,
						trigger_times = 1,
						toggle = 'on',
						base_delay = 0
					}
				})
				table.insert(itr_custom_elements, bus_id)
				table.insert(element.values.on_executed, {id = bus_id, delay = 0})
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'vit' then

	function MissionManager:_add_script(data)
		for _, element in pairs(data.elements) do
			if element.id == 104080 then
				element.class = 'ElementDeleteVehicle'
				element.values.unit_ids = {101268}
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'firestarter_1' then

	function MissionManager:_add_script(data)
		table.insert(itr_custom_elements, 105000)

		for _, element in pairs(data.elements) do
			if element.id == 100411 then
				local ai_graph = CoreTable.deep_clone(element)
				ai_graph.id = 105000
				ai_graph.values.graph_ids[1] = 24
				table.insert(data.elements, ai_graph)
			elseif element.id == 100409 then
				table.insert(element.values.on_executed, { delay = 0, id = 105000 })
			elseif element.id == 104355 or element.id == 104356 then
				local new_seq = CoreTable.deep_clone(element.values.sequence_list[1])
				new_seq.sequence = 'int_seq_bullet_hit'
				table.insert(element.values.sequence_list, new_seq)
			end
		end

		itr_original_missionmanager_addscript(self, data)
	end

elseif level_id == 'mex' then

	function MissionScript:_create_elements(elements)
		for _, element in pairs(elements) do
			if element.id == 138008 or element.id == 138308 or element.id == 138608 then
				if element.values.so_action == 'e_so_disarm_bomb' then
					element.values.path_style = 'destination'
					element.values.align_position = true
					element.values.align_rotation = true
					element.values.needs_pos_rsrv = true
					element.values.scan = true
				end
			elseif element.id == 155171 then -- mex_plane_cessna_003
				for k, v in pairs(element.values.obstacle_list) do
					if v.unit_id == 155459 then
						table.remove(element.values.obstacle_list, k)
					end
				end
			elseif element.id == 156171 then -- mex_plane_cessna_004
				for k, v in pairs(element.values.obstacle_list) do
					if v.unit_id == 156459 then
						table.remove(element.values.obstacle_list, k)
					end
				end
			elseif element.id == 102412 then
				local id_disable_area_kill = 150400
				table.insert(element.values.on_executed, { delay = 10, id = id_disable_area_kill })

				local element2 = CoreTable.deep_clone(element)
				element2.id = id_disable_area_kill
				element2.editor_name = 'disable_triggers_in_arizona'
				element2.values.toggle = 'off'
				element2.values.on_executed = {}

				table.insert(elements, element2)
				table.insert(itr_custom_elements, id_disable_area_kill)
			elseif element.id == 100215 then
				element.values.path_style = 'destination'
				element.values.patrol_path = 'none'
			end
		end

		return itr_original_missionscript_createelements(self, elements)
	end

end
