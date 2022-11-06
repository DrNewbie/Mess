_G.HeistChaaaaaaaaaaaaain = _G.HeistChaaaaaaaaaaaaain or {}

HeistChaaaaaaaaaaaaain.menu_id = "_heist_chaaaaaaaaaaaaain_menu_id"
HeistChaaaaaaaaaaaaain.ModPath = ModPath
HeistChaaaaaaaaaaaaain.Level_Num = HeistChaaaaaaaaaaaaain.Level_Num or 0


Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_HeistChaaaaaaaaaaaaain", function(menu_manager, nodes)
	MenuHelper:NewMenu(HeistChaaaaaaaaaaaaain.menu_id)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_HeistChaaaaaaaaaaaaain", function(menu_manager, nodes)
		MenuCallbackHandler.GetHeistChaaaaaaaaaaaaainNow = function(self, item)
			if tweak_data and tweak_data.narrative and tweak_data.levels then
				local _file = io.open(HeistChaaaaaaaaaaaaain.ModPath .. "/lua/tweakdata.lua", "w+")
				if not _file then
					return
				end
				local _ok2use = {
					--[[ Req. fix, I guess ]]
					--[[
						"welcome_to_the_jungle_1",
						"welcome_to_the_jungle_1_night",
						"welcome_to_the_jungle_2",
						"framing_frame_1",
						"framing_frame_2",
						"framing_frame_3",
						"election_day_1",
						"election_day_2",
						"election_day_3",
						"watchdogs_1",
						"watchdogs_2",
						"watchdogs_1_night",
						"watchdogs_2_day",
						"alex_1",
						"alex_2",
						"alex_3",
						"firestarter_1",
						"firestarter_2",
						"firestarter_3",
						"mia_1",
						"mia_2",
						"mia2_new",
					]]
					"ukrainian_job",
					"jewelry_store",
					"four_stores",
					"mallcrasher",
					"nightclub",
					"branchbank",
					"arm_fac",
					"arm_par",
					"arm_hcm",
					"arm_cro",
					"arm_und",
					"arm_for",
					"family",
					"big",
					"kosugi",
					"gallery",
					"hox_1",
					"hox_2",
					"pines",
					"cage",
					"hox_3",
					"mus",
					"crojob2",
					"crojob3",
					"crojob3_night",
					"rat",
					"shoutout_raid",
					"arena",
					"kenaz",
					"jolly",
					"cane",
					"red2",
					"dinner",
					"pbr",
					"pbr2",
					"peta",
					"peta2",
					"pal",
					"nail",
					"man",
					"dark",
					"mad",
					"born",
					"chew",
					"chill_combat",
					"friend",
					"flat",
					"help",
					"haunted",
					"moon",
					"spa",
					"fish",
					"run",
					"glace",
					"dah",
					"rvd1",
					"rvd2",
					"hvh",
					"wwh",
					"brb",
					"tag",
					"des",
					"nmh",
					"sah",
					"vit",
					"bph",
					"mex",
					"bex",
					"pex",
					"fex",
					"chas",
					"sand",
					"chca",
					"pent",
					"ranc",
					"trai"
				}
				_ok2use = table.shuffled_copy(_ok2use)
				local _blocklevel = {}
				_file:write('_G.HeistChaaaaaaaaaaaaain = _G.HeistChaaaaaaaaaaaaain or {}\n')
				_file:write('HeistChaaaaaaaaaaaaain.Level_Num = '.. #_ok2use ..'\n')
				_file:write('if not tweak_data then\n')
				_file:write('	return\n')
				_file:write('end\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"] = {}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].name_id = "heist_chaaaaaaaaaaaaain"\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].briefing_id = "heist_short1_stage1_crimenet"\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contact = "events"\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].region = "street"\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].jc = 10\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].briefing_event = "pln_sh11_cbf_01"\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].debrief_event = nil\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].crimenet_callouts = {\n')
				_file:write('	"pln_cs1_cnc_01",\n')
				_file:write('	"pln_cs1_cnc_02",\n')
				_file:write('	"pln_cs1_cnc_03"\n')
				_file:write('}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].crimenet_videos = {\n')
				_file:write('	"cn_branchbank1",\n')
				_file:write('	"cn_branchbank2",\n')
				_file:write('	"cn_branchbank3"\n')
				_file:write('}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].payout = {0, 0, 0, 0, 0, 0, 0}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_cost = {0, 0, 0, 0, 0, 0, 0}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_visuals = {}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_visuals.min_mission_xp = {0, 0, 0, 0, 0, 0, 0}\n')
				_file:write('tweak_data.narrative.jobs["chaaaaaaaaaaaaain"].contract_visuals.max_mission_xp = {0, 0, 0, 0, 0, 0, 0}\n')
				_file:write('tweak_data.levels["chaaaaaaaaaaaaain"] = deep_clone(tweak_data.levels["branchbank"])\n')
				_file:write('tweak_data.levels["chaaaaaaaaaaaaain"].name_id = "heist_chaaaaaaaaaaaaain"\n')
				_file:write('table.insert(tweak_data.narrative._jobs_index, "chaaaaaaaaaaaaain")\n')
				_file:write('table.insert(tweak_data.levels._level_index, "chaaaaaaaaaaaaain")\n')
				_blocklevel = {}
				local _u = 0
				while _u < #_ok2use do
					_u = _u + 1
					_file:write('tweak_data.experience_manager.day_multiplier['.. _u ..'] = 1\n')
					_file:write('tweak_data.experience_manager.pro_day_multiplier['.. _u ..'] = 1\n')
					_file:write('tweak_data.experience_manager.stage_completion['.. _u ..'] = 1\n')
					_file:write('tweak_data.experience_manager.job_completion['.. _u ..'] = 1\n')
					_file:write('tweak_data.experience_manager.day_multiplier['.. _u ..'] = 1\n')
				end
				_u = 0
				_file:write('tweak_data.narrative.jobs.chaaaaaaaaaaaaain.chain = {\n')
				while _u < (#_ok2use)-1 do
					_u = _u + 1
					_file:write('	{level_id = "'.. _ok2use[_u] ..'", type_id = "heist_type_assault", type = "d"},\n')
				end
				_file:write('	{level_id = "'.. _ok2use[#_ok2use] ..'", type_id = "heist_type_assault", type = "d"}\n')
				_file:write('}\n')
				_file:close()
				QuickMenu:new(
					managers.localization:text("menu_heistchaaaaaaaaaaaaain_contract_name"),
					managers.localization:text("menu_heistchaaaaaaaaaaaaain_update_desc"),
					{
						{"OK", is_cancel_button = true}
					},
					true
				):Show()
			end
		end
		MenuHelper:AddButton({
			id = "GetHeistChaaaaaaaaaaaaainNow",
			title = "menu_heistchaaaaaaaaaaaaain_contract_name",
			desc = "menu_heistchaaaaaaaaaaaaain_contract_desc",
			callback = "GetHeistChaaaaaaaaaaaaainNow",
			menu_id = HeistChaaaaaaaaaaaaain.menu_id,
		})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_HeistChaaaaaaaaaaaaain", function(menu_manager, nodes)
	nodes[HeistChaaaaaaaaaaaaain.menu_id] = MenuHelper:BuildMenu(HeistChaaaaaaaaaaaaain.menu_id)
	MenuHelper:AddMenuItem(nodes["blt_options"], HeistChaaaaaaaaaaaaain.menu_id, "menu_heistchaaaaaaaaaaaaain_contract_name", "menu_heistchaaaaaaaaaaaaain_contract_desc")
end)

Hooks:Add("LocalizationManagerPostInit", "HeistChaaaaaaaaaaaaain_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_heistchaaaaaaaaaaaaain_contract_name"] = "Update Heist Chaaaaaaaaaaaaain",
		["menu_heistchaaaaaaaaaaaaain_contract_desc"] = " ...",
		["menu_heistchaaaaaaaaaaaaain_update_desc"] = "Data is updated.\nPlease reboot the game.",
		["heist_chaaaaaaaaaaaaain"] = "Heist Chaaaaaaaaaaaaain"
	})
end)

if ModCore then
	ModCore:new(HeistChaaaaaaaaaaaaain.ModPath .. "Config.xml", false, true):init_modules()
end