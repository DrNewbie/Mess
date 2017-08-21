_G.LaterMyFriendMenu = _G.LaterMyFriendMenu or {}

if not LuaNetworking:IsHost() or not LaterMyFriendMenu or not LaterMyFriendMenu._data then
	return
end

Hooks:Add("NetworkManagerOnPeerAdded", "LaterMyFriendRun", function(peer, peer_id)
	if not Utils:IsInHeist() then 
		return
	end
	DelayedCalls:Add("LaterMyFriendRun_Peer_" .. tostring(peer_id), 1, function()
		if peer and peer.user_id then
			local function _t()
				return math.round(tonumber(os.date("%H"))*3600 + tonumber(os.date("%M"))*60 + tonumber(os.date("%S")) + 1)
			end
			local _user_id = "ID__" .. tostring(peer:user_id())
			local _now_t = _t()
			if _now_t and _now_t > 0 then
				LaterMyFriendMenu._data._users = LaterMyFriendMenu._data._users or {}
				LaterMyFriendMenu._data._times = LaterMyFriendMenu._data._times or 0
				LaterMyFriendMenu._data._users[_user_id] = LaterMyFriendMenu._data._users[_user_id] or {}
				LaterMyFriendMenu._data._users[_user_id]._last_t = LaterMyFriendMenu._data._users[_user_id]._last_t or 0
				LaterMyFriendMenu._data._users[_user_id]._times = LaterMyFriendMenu._data._users[_user_id]._times or 0
				LaterMyFriendMenu._data._users[_user_id]._times = LaterMyFriendMenu._data._users[_user_id]._times + 1
				if LaterMyFriendMenu._data._users[_user_id]._times > LaterMyFriendMenu._data._times then
					if LaterMyFriendMenu._data._users[_user_id] then
						local _last_t = LaterMyFriendMenu._data._users[_user_id]._last_t
						local _diff_t = _now_t - _last_t
						if _diff_t < LaterMyFriendMenu._data._delay then
							managers.network:session():on_peer_kicked(peer, peer:id(), 0)
							managers.network:session():send_to_peers("kick_peer", peer:id(), 2)						
						end
					end
				end
				LaterMyFriendMenu._data._users[_user_id]._last_t = _now_t
				LaterMyFriendMenu:Save()
			end
		end
	end)
end)