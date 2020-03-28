local ThisModPath = ModPath
local __menu_possible = {
	"all_ovk",
	"all_ew",
	"all_dw",
	"all_sm",
	"stealth_ovk",
	"stealth_ew",
	"stealth_dw",
	"stealth_sm",
	"stealth_sm_od",
	"loud_ovk",
	"loud_ew",
	"loud_dw",
	"loud_sm",
	"loud_sm_od"
}
local __roll_contract_blacklist = {"__"}

function __roll_contract_blacklist_save()
	local _file = io.open(ThisModPath.."__blacklist.txt", "w+")
	if _file then
		_file:write(json.encode(__roll_contract_blacklist))
		_file:close()
	end
end

function __roll_contract_blacklist_load()
	local _file = io.open(ThisModPath.."__blacklist.txt", "r")
	if _file then
		__roll_contract_blacklist = json.decode(_file:read("*all"))
		_file:close()
	else
		__roll_contract_blacklist = {["__"] = true}
		__roll_contract_blacklist_save()
		__roll_contract_blacklist_load()
	end
end

__roll_contract_blacklist_load()

Hooks:Add("LocalizationManagerPostInit", "RandomContract_loc", function(loc)
	loc:load_localization_file(ThisModPath.."Loc.txt")
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_RandomContract", function(menu_manager, nodes)
	if nodes["lobby"] then
		MenuHelper:NewMenu("menu_roll_contract")
	end
	MenuHelper:NewMenu("menu_roll_contract_blacklist")
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_RandomContract", function(menu_manager, nodes)
	if nodes["lobby"] and (not LuaNetworking:IsMultiplayer() or (LuaNetworking:IsMultiplayer() and LuaNetworking:IsHost())) then
		nodes["menu_roll_contract"] = MenuHelper:BuildMenu("menu_roll_contract")
		MenuHelper:AddMenuItem(nodes["lobby"], "menu_roll_contract", "menu_roll_contract_name", "menu_roll_contract_desc")
	end
	nodes["menu_roll_contract_blacklist"] = MenuHelper:BuildMenu("menu_roll_contract_blacklist")
	MenuHelper:AddMenuItem(nodes["blt_options"], "menu_roll_contract_blacklist", "menu_roll_contract_blacklist_name", "menu_roll_contract_blacklist_desc")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_RandomContract", function(menu_manager, nodes)
	if nodes.lobby then
		MenuCallbackHandler.Random_Contract_Now = function(self, item)
			local create_job =  function(data)
				local difficulty_id = tweak_data:difficulty_to_index(data.difficulty)
				managers.money:on_buy_premium_contract(data.job_id, difficulty_id)
				managers.job:on_buy_job(data.job_id, difficulty_id)
				MenuCallbackHandler:save_progress()
				if Global.game_settings.single_player then
					MenuCallbackHandler:start_single_player_job(data)
				else
					MenuCallbackHandler:start_job(data)
				end
			end
			local __job = {}
			local job_id_list = tweak_data.narrative:get_jobs_index()
			local rnd_job_id_list = {}
			local job_tweak_data, is_not_dlc_or_got, choose_job, can_afford, retries
			local retry_limit = 10
			local _priority = tostring(item._priority)
			local _difficult = "overkill_145"
			if _priority:find("dw") then
				_difficult = "overkill_290"
			end
			if _priority:find("ew") then
				_difficult = "easy_wish"
			end
			if _priority:find("sm") then
				_difficult = "sm_wish"
			end
			if _priority:find("od") then
				__job.one_down = true
			else
				__job.one_down = false
			end
			if _priority:find("loud") then
				for k, job in pairs(job_id_list) do
					if not __roll_contract_blacklist[job] then
						for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
							if day and day.level_id and tweak_data.levels[day.level_id] then
								if not tweak_data.levels[day.level_id].ghost_bonus then
									table.insert(rnd_job_id_list, job)
								end
							end
						end
					end
				end
			elseif _priority:find("stealth") then
				for k, job in pairs(job_id_list) do
					if not __roll_contract_blacklist[job] then
						for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
							if day and day.level_id and tweak_data.levels[day.level_id] then
								if tweak_data.levels[day.level_id].ghost_bonus then
									table.insert(rnd_job_id_list, job)
								end
							end
						end
					end
				end
			else
				rnd_job_id_list = job_id_list
			end
			if not rnd_job_id_list or #rnd_job_id_list < 1 then
				return				
			end
			while (not is_not_dlc_or_got or not can_afford) and ((retries or 0) < retry_limit) do
				choose_job = rnd_job_id_list[math.random(#rnd_job_id_list)]
				job_tweak_data = tweak_data.narrative.jobs[choose_job]
				is_not_dlc_or_got = not job_tweak_data.dlc or managers.dlc:is_dlc_unlocked(job_tweak_data.dlc)
				can_afford = managers.money:can_afford_buy_premium_contract(choose_job, tweak_data:difficulty_to_index(_difficult))
				retries = (retries or 0) + 1
			end
			if retries and retries < retry_limit then
				__job.difficulty = _difficult
				__job.job_id = choose_job
				create_job(__job)
			else
				QuickMenu:new(
					"Random Contrect",
					"Looks like you can't afford any random heist currently. sorry.",
					{
						{"Ok", is_cancel_button = true}
					},
					true
				)
			end
		end
		for _, _opt in pairs(__menu_possible) do
			MenuHelper:AddButton({
				id = "roll_contract_".._opt,
				title = "roll_contract_".._opt.."_title",
				desc = "roll_contract_".._opt.."_desc",
				callback = "Random_Contract_Now",
				priority = "roll_contract_".._opt,
				menu_id = "menu_roll_contract"
			})
		end
	end
	local __job_id_list = tweak_data.narrative:get_jobs_index()
	for k, job in pairs(__job_id_list) do
		local job_data = tweak_data.narrative.jobs[job]
		local __ids_key = Idstring("menu_roll_contract_blacklist_"..job):key()
		MenuCallbackHandler["C_"..__ids_key] = function(self, item)
			if tostring(item:value()) == "on" then
				__roll_contract_blacklist[job] = true
			else
				__roll_contract_blacklist[job] = false
			end
			__roll_contract_blacklist_save()
		end
		MenuHelper:AddToggle({
			id = "M_"..__ids_key,
			title = managers.localization:to_upper_text(tostring(job_data.name_id or job_data.description_id)).." -- "..managers.localization:to_upper_text(tostring(job_data.contact and (tweak_data.narrative.contacts[job_data.contact].name_id or tweak_data.narrative.contacts[job_data.contact].description_id) or "nil")),
			callback = "C_"..__ids_key,
			value = __roll_contract_blacklist[job] and true or false,
			menu_id = "menu_roll_contract_blacklist",
			localized = false
		})
	end
end)

if RequiredScript == "lib/managers/crimenetmanager" then
	Hooks:PostHook(CrimeNetGui, "init", "F_"..Idstring("PostHook:CrimeNetGui:init:RandomContract"):key(), function(self, ws, fullscreeen_ws, node)
		if Global.game_settings.single_player then
			for _i, _opt in pairs(__menu_possible) do
				local __roll_contract = self._panel:text({
					name = "__roll_contract_".._opt,
					text = "--> "..managers.localization:to_upper_text("roll_contract_".._opt.."_title"),
					font_size = tweak_data.menu.pd2_small_font_size,
					font = tweak_data.menu.pd2_small_font,
					color = tweak_data.screen_colors.button_stage_3,
					layer = 40,
					y = 80 + tweak_data.menu.pd2_small_font_size * (_i - 1) * 1.5,
					blend_mode = "add"
				})
				self:make_fine_text(__roll_contract)
				__roll_contract:set_right(self._panel:w() - 10)
			end
		end
	end)
	local orig_mouse_pressed = CrimeNetGui.mouse_pressed
	function CrimeNetGui:mouse_pressed(o, button, x, y, ...)
		if not self._crimenet_enabled or self._getting_hacked then
			return
		end
		for _i, _opt in pairs(__menu_possible) do
			local __button = self._panel:child("__roll_contract_".._opt)
			if alive(__button) then
				if __button:inside(x, y) then
					MenuCallbackHandler:Random_Contract_Now({_priority = "roll_contract_".._opt})
					return true
				end
			end
		end
		return orig_mouse_pressed(self, o, button, x, y, ...)
	end
	Hooks:PostHook(CrimeNetGui, "mouse_moved", "F_"..Idstring("PostHook:CrimeNetGui:mouse_moved:RandomContract"):key(), function(self, o, x, y)
		if not self._crimenet_enabled or self._getting_hacked then
		
		else
			for _i, _opt in pairs(__menu_possible) do
				local __button = self._panel:child("__roll_contract_".._opt)
				local __highlighted = "__roll_contract__highlighted_".._opt
				if alive(__button) then
					if __button:inside(x, y) then
						if not self[__highlighted] then
							self[__highlighted] = true
							__button:set_color(tweak_data.screen_colors.risk)
							managers.menu_component:post_event("highlight")
						end
					elseif self[__highlighted] then
						self[__highlighted] = false
						__button:set_color(tweak_data.screen_colors.button_stage_3)
					end
				end
			end
		end
	end)
end