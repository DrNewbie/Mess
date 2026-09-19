local set_attributes_original = NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	settings.numbers[3] = 3
	set_attributes_original(self, settings, ...)
end

local is_server_ok_original = NetworkMatchMakingSTEAM.is_server_ok
function NetworkMatchMakingSTEAM:is_server_ok(...)
	return false
end