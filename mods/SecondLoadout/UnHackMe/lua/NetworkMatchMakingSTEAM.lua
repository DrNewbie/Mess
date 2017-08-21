
-- This prevents creatings public lobbies
-- yes, the option got removed already, but the default is still "public" if no other option chosen
local set_attributes_original = NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	if settings.numbers[3] == 1 then
		settings.numbers[3] = 2
	end
	set_attributes_original(self, settings, ...)
end

-- This filters out public servers
local is_server_ok_original = NetworkMatchMakingSTEAM.is_server_ok
function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_numbers, is_invite, ...)
	if attributes_numbers[3] == 1 then
		return false
	end
	is_server_ok_original(self, friends_only, room, attributes_numbers, is_invite, ...)
end
