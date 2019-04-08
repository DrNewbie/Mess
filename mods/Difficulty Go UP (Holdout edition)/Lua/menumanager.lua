function MenuCallbackHandler:Change_skirmish_contract()
	Global.game_settings.difficulty = "normal"
	local matchmake_attributes = MenuCallbackHandler:get_matchmake_attributes()
	if Network:is_server() then
		local job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
		local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
		local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
		local one_down = Global.game_settings.one_down
		managers.network:session():send_to_peers("sync_game_settings", job_id_index, level_id_index, difficulty_index, one_down)
		managers.network.matchmake:set_server_attributes(matchmake_attributes)
		managers.mutators:update_lobby_info()
		managers.menu_component:on_job_updated()
		managers.menu:open_node("lobby")
		managers.menu:active_menu().logic:refresh_node("lobby", true)
	else
		managers.network.matchmake:create_lobby(matchmake_attributes)
	end
end

Hooks:PostHook(MenuCallbackHandler, "accept_skirmish_contract", Idstring("CHOD.accept_skirmish_contract"):key(), function(self)
	MenuCallbackHandler:Change_skirmish_contract()
end)

Hooks:PostHook(MenuCallbackHandler, "accept_skirmish_weekly_contract", Idstring("CHOD.accept_skirmish_contract"):key(), function(self)
	MenuCallbackHandler:Change_skirmish_contract()
end)