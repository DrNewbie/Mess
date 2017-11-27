local Armor8_set_attributes_original = NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	if not self:AddOnArmourSyncFix() then
		if settings.numbers[3] < 3 then
			settings.numbers[3] = 3
		end
	end
	Armor8_set_attributes_original(self, settings, ...)
end

local Armor8_is_server_ok_original = NetworkMatchMakingSTEAM.is_server_ok
function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_list, is_invite)
	if not self:AddOnArmourSyncFix() then
		if attributes_list.numbers and attributes_list.numbers[3] < 3 then
			return false
		end
	end
	Armor8_is_server_ok_original(self, friends_only, room, attributes_list, is_invite)
end