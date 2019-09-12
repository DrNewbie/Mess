Hooks:PreHook(BaseNetworkSession, "on_peer_kicked", "AutoBanHostDueToFunAndNoReason", function(self, peer, peer_id)	
	if managers.ban_list and peer == self._local_peer and peer ~= self._server_peer then
		managers.ban_list:ban(self._server_peer:user_id(), tostring(self._server_peer:user_id()))
	end
end)