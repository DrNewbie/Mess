Hooks:Add("LocalizationManagerPostInit", "RandomContract_loc", function(loc)
	LocalizationManager:add_localized_strings({
    ["menu_roll_contract"] = "Random contract",
    ["menu_roll_contract_name"] = "Random contract",
    ["menu_roll_contract_desc"] = "Change your contract to something random",
	
    ["roll_contract_all_ovk_title"] = "ALL OVERKILL",
    ["roll_contract_all_ovk_desc"] = "Give you random contract in OVERKILL",
    ["roll_contract_all_ew_title"] = "ALL MAYHEM",
    ["roll_contract_all_ew_desc"] = "Give you random contract in MAYHEM",
    ["roll_contract_all_dw_title"] = "ALL DEATH WISH",
    ["roll_contract_all_dw_desc"] = "Give you random contract in DEATH WISH",
    ["roll_contract_all_od_title"] = "ALL ONE DOWN",
    ["roll_contract_all_od_desc"] = "Give you random contract in ONE DOWN",
	
    ["roll_contract_loud_ovk_title"] = "LOUD OVERKILL",
    ["roll_contract_loud_ovk_desc"] = "Give you random loud contract in OVERKILL",
    ["roll_contract_loud_ew_title"] = "LOUD MAYHEM",
    ["roll_contract_loud_ew_desc"] = "Give you random loud contract in MAYHEM",
    ["roll_contract_loud_dw_title"] = "LOUD DEATH WISH",
    ["roll_contract_loud_dw_desc"] = "Give you random loud contract in DEATH WISH",
    ["roll_contract_loud_od_title"] = "LOUD ONE DOWN",
    ["roll_contract_loud_od_desc"] = "Give you random loud contract in ONE DOWN",
	
    ["roll_contract_stealth_ovk_title"] = "Stealth OVERKILL",
    ["roll_contract_stealth_ovk_desc"] = "Give you random stealth contract in OVERKILL",
    ["roll_contract_stealth_ew_title"] = "Stealth MAYHEM",
    ["roll_contract_stealth_ew_desc"] = "Give you random stealth contract in MAYHEM",
    ["roll_contract_stealth_dw_title"] = "Stealth DEATH WISH",
    ["roll_contract_stealth_dw_desc"] = "Give you random stealth contract in DEATH WISH",
    ["roll_contract_stealth_od_title"] = "Stealth ONE DOWN",
    ["roll_contract_stealth_od_desc"] = "Give you random stealth contract in ONE DOWN"
  })
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_RandomContract", function(menu_manager, nodes)
	if nodes["lobby"] then
		MenuHelper:NewMenu( "menu_roll_contract" )
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_RandomContract", function(menu_manager, nodes)
	if nodes["lobby"] and ( not LuaNetworking:IsMultiplayer() or ( LuaNetworking:IsMultiplayer() and LuaNetworking:IsHost() ) ) then
		nodes["menu_roll_contract"] = MenuHelper:BuildMenu( "menu_roll_contract" )
		MenuHelper:AddMenuItem(nodes["lobby"], "menu_roll_contract", "menu_roll_contract_name", "menu_roll_contract_desc" )
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_RandomContract", function(menu_manager, nodes)
	if nodes.lobby then
		MenuCallbackHandler.Random_Contract_Now = function(self, item)
			local create_job =  function(data)
				local difficulty_id = tweak_data:difficulty_to_index(data.difficulty)
				managers.money:on_buy_premium_contract(data.job_id, difficulty_id)
				managers.job:on_buy_job(data.job_id, difficulty_id)
				MenuCallbackHandler:start_job({job_id = data.job_id, difficulty = data.difficulty})
				MenuCallbackHandler:save_progress()
			end
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
			if _priority:find("od") then
				_difficult = "sm_wish"
			end
			if _priority:find("loud") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if not tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
							end
						end
					end
				end
			elseif _priority:find("stealth") then
				for k, job in pairs(job_id_list) do
					for k2, day in pairs(tweak_data.narrative.jobs[job].chain) do
						log(tostring(day))
						if day and day.level_id and tweak_data.levels[day.level_id] then
							if tweak_data.levels[day.level_id].ghost_bonus then
								table.insert(rnd_job_id_list, job)
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
				choose_job = rnd_job_id_list[math.random( #rnd_job_id_list )]
				job_tweak_data = tweak_data.narrative.jobs[choose_job]
				is_not_dlc_or_got = not job_tweak_data.dlc or managers.dlc:is_dlc_unlocked(job_tweak_data.dlc)
				can_afford = managers.money:can_afford_buy_premium_contract(choose_job, tweak_data:difficulty_to_index(_difficult))
				retries = (retries or 0) + 1
			end
			if retries and retries < retry_limit then
				create_job({ difficulty = _difficult, job_id = choose_job })
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
		MenuHelper:AddButton({
			id = "roll_contract_all_ovk",
			title = "roll_contract_all_ovk_title",
			desc = "roll_contract_all_ovk_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_all_ovk",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_all_ew",
			title = "roll_contract_all_ew_title",
			desc = "roll_contract_all_ew_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_all_ew",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_all_dw",
			title = "roll_contract_all_dw_title",
			desc = "roll_contract_all_dw_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_all_dw",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_all_od",
			title = "roll_contract_all_od_title",
			desc = "roll_contract_all_od_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_all_od",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_loud_ovk",
			title = "roll_contract_loud_ovk_title",
			desc = "roll_contract_loud_ovk_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_loud_ovk",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_loud_ew",
			title = "roll_contract_loud_ew_title",
			desc = "roll_contract_loud_ew_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_loud_ew",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_loud_dw",
			title = "roll_contract_loud_dw_title",
			desc = "roll_contract_loud_dw_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_loud_dw",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_loud_od",
			title = "roll_contract_loud_od_title",
			desc = "roll_contract_loud_od_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_loud_od",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_stealth_ovk",
			title = "roll_contract_stealth_ovk_title",
			desc = "roll_contract_stealth_ovk_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_stealth_ovk",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_stealth_ew",
			title = "roll_contract_stealth_ew_title",
			desc = "roll_contract_stealth_ew_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_stealth_ew",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_stealth_dw",
			title = "roll_contract_stealth_dw_title",
			desc = "roll_contract_stealth_dw_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_stealth_dw",
			menu_id = "menu_roll_contract",
		})
		MenuHelper:AddButton({
			id = "roll_contract_stealth_od",
			title = "roll_contract_stealth_od_title",
			desc = "roll_contract_stealth_od_desc",
			callback = "Random_Contract_Now",
			priority = "roll_contract_stealth_od",
			menu_id = "menu_roll_contract",
		})
	end
end)