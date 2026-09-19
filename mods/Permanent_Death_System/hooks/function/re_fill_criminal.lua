local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.re_fill_criminal then
	return
else
	DeadManSysMain._hooks.re_fill_criminal = true
end

if not DeadManSysMain._funcs.__IsHost() then
	return
end

--[[
	Re-fill AI by forced
]]
Hooks:PostHook(GroupAIStateBase, "fill_criminal_team_with_AI", DeadManSysMain.__Name("re:re_fill_criminal"), function(self, is_drop_in, ...)
	if managers.navigation:is_data_ready() and self._ai_enabled and managers.groupai:state():team_ai_enabled() then
		local char_name = managers.criminals:get_free_character_name()
		while char_name and not managers.criminals:is_taken(char_name) and table.size(self._player_criminals) < CriminalsManager.MAX_NR_CRIMINALS and table.size(self._ai_criminals) < managers.criminals.MAX_NR_TEAM_AI do
			if not self:spawn_one_teamAI(is_drop_in or not not char_name, char_name, nil, nil, true) then
				break
			end
			char_name = managers.criminals:get_free_character_name()
		end
	end
end)