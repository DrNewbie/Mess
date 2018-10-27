if Network:is_client() then
	return
end

local set_attributes_original = NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	if settings.numbers[3] == 1 then
		settings.numbers[3] = 2
	end
	set_attributes_original(self, settings, ...)
end
