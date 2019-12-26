if not Network or Network:is_client() then
	return
end

Hooks:PostHook(DialogManager, "queue_dialog", "F_"..Idstring("PostHook:DialogManager:queue_dialog:Infinite Hoxton Breakout"):key(), function(self)
	if Global.game_settings and Global.game_settings.level_id == "hox_1" and not self._infinite_hoxton_breakout then
		self._infinite_hoxton_breakout = true
		managers.job:set_next_interupt_stage("hox_1")
	end
end)