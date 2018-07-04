local NOSALOBBY_is_server_ok = NetworkMatchMakingSTEAM.is_server_ok
function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_list, ...)
	if attributes_list.numbers[11] ~= "value_pending" then
		return false
	end
	return NOSALOBBY_is_server_ok(self, friends_only, room, attributes_list, ...)
end

local NOSALOBBY_lobby_to_numbers = NetworkMatchMakingSTEAM._lobby_to_numbers
function NetworkMatchMakingSTEAM._lobby_to_numbers(self, lobby, ...)
	local numbers = NOSALOBBY_lobby_to_numbers(self, lobby, ...)
	table.insert(numbers, lobby:key_value("silent_assassin"))
	return numbers
end