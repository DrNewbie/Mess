local old_is_server_ok = NetworkMatchMakingEPIC.is_server_ok
function NetworkMatchMakingEPIC:is_server_ok(friends_only, room, ...)
	local owner_account_id = tostring(room.owner_account_id)
	if string.len(owner_account_id) > 17 then
		return false
	end
	return old_is_server_ok(self, friends_only, room, ...)
end