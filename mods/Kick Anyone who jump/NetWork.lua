Hooks:PostHook(UnitNetworkHandler, "action_jump", Idstring("NoJump.UnitNetworkHandler.action_jump"):key(), function(self, unit, pos, jump_vec, sender)
	if not managers.network:session() or not managers.network:session():is_host() then
		return
	end
	if not self._verify_character_and_sender(unit, sender) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end
	if not alive(unit) then
		return
	end
	local session = managers.network:session()
	local peer = nil
	if session then
		peer = sender:protocol_at_index(0) == "STEAM" and session:peer_by_user_id(sender:ip_at_index(0)) or session:peer_by_ip(sender:ip_at_index(0))
		if peer then
			session:on_peer_kicked(peer, peer:id(), 0)
			session:send_to_peers("kick_peer", peer:id(), 0)
			if managers.chat then
				managers.chat:_receive_message(ChatManager.GAME, "[NoJump]", peer:name().." was kicked due to 'jump'", Color.red)
			end
		end
	end
end)