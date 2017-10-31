Hooks:PostHook(StatisticsManager, "killed", "Ghost145Plus_StatisticsManager_killed", function(self)
	if Network:is_server() and m_ghost:in_stealth() then
		local casualties = self:session_total_civilian_kills()
		if m_ghost:mode() > 1 and casualties > 0 then
			managers.groupai._state:on_police_called("sys_police_alerted")
		end
	end
end)