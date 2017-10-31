if Network:is_client() then
	return
end

local set_attributes_original = NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	if settings.numbers[3] == 1 then
		settings.numbers[3] = 2
	end
	SurvivorModeBase:Mod_Enable_Warning_Host()
	set_attributes_original(self, settings, ...)
end

local is_server_ok_original = NetworkMatchMakingSTEAM.is_server_ok
function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_numbers, is_invite, ...)
	if attributes_numbers[3] == 1 then
		return false
	end
	return is_server_ok_original(self, friends_only, room, attributes_numbers, is_invite, ...)
end
