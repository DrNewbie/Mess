local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mic_original_huskcopmovement_actionrequest = HuskCopMovement.action_request
function HuskCopMovement:action_request(action_desc)
	if action_desc.variant == 'tied' then
		self._unit:base().mic_is_being_moved = nil
		self._unit:base().mic_destination = nil
	end

	return mic_original_huskcopmovement_actionrequest(self, action_desc)
end
