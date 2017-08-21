if RequiredScript == "lib/network/base/networkpeer" then
	if Hooks then
		Hooks:Add("NetworkManagerOnPeerAdded", "SomeoneJoinOnPeerAdded", 
		function(peer, id)
			managers.menu:post_event("infamous_player_join_stinger")
		end)
	end
end