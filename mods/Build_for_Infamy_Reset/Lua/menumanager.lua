Hooks:PreHook(MenuCallbackHandler, '_increase_infamous', 'F_'..Idstring('PreHook:build4reset:_increase_infamous'):key(), function(self)
	local build_index = 0
	if managers.multi_profile and managers.multi_profile._global and managers.multi_profile._global._profiles then
		for i, data in pairs(managers.multi_profile._global._profiles) do
			if string.lower(tostring(data.name)) ==  string.lower("build4reset") then
				build_index = i
				break
			end
		end
	end
	if build_index > 0 then
		--[[ Set to that build]]
		managers.multi_profile:set_current_profile(build_index)
		
		managers.menu_scene:destroy_infamy_card()
		local max_rank = tweak_data.infamy.ranks
		if managers.experience:current_level() < 100 or max_rank <= managers.experience:current_rank() then
			return
		end
		local rank = managers.experience:current_rank() + 1
		managers.experience:reset()
		managers.experience:set_current_rank(rank)
		local offshore_cost = managers.money:get_infamous_cost(rank)
		if offshore_cost > 0 then
			managers.money:deduct_from_total(managers.money:total(), TelemetryConst.economy_origin.increase_infamous)
			managers.money:deduct_from_offshore(offshore_cost)
		end
		
		--No need
		--[[
			managers.skilltree:infamy_reset()
			managers.multi_profile:infamy_reset()
			managers.blackmarket:reset_equipped()
		]]
		
		--Reset This Build
		for tree, _ in pairs(tweak_data.skilltree.trees) do
			managers.skilltree:_reset_skilltree(tree)
		end
		managers.skilltree:_verify_loaded_data(0)
		
		if managers.menu_component then
			managers.menu_component:refresh_player_profile_gui()
		end
		local logic = managers.menu:active_menu().logic
		if logic then
			logic:refresh_node()
			logic:select_item("crimenet")
		end
		managers.savefile:save_progress()
		managers.savefile:save_setting(true)
		managers.menu:post_event("infamous_player_join_stinger")
		if yes_clbk then
			yes_clbk()
		end
		if SystemInfo:distribution() == Idstring("STEAM") then
			managers.statistics:publish_level_to_steam()
		end
		return
	end
end)