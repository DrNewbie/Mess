Hooks:PostHook(HUDLootScreen, "begin_choose_card", "AutoCasino_HUDLootScreen", function(self, peer_id)
	self._peer_data[peer_id].wait_t = 0
end)