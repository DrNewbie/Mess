if not Network or Network:is_client() then
	return
end

Hooks:PostHook(DialogManager, "queue_dialog", "ActiveOverBurnEvent", function(self, id)
	if managers.job:current_level_id() == "red2" and id == "Play_pln_fwb_01" then
		managers.groupai:state():on_police_called("alarm_pager_hang_up")
	end
end)