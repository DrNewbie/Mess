Hooks:PostHook(PlayerManager, "init_finalize", "F_"..Idstring("PostHook:PlayerManager:init_finalize:Glove Boosts Test 101"):key(), function(self)
	local __glove = tostring(managers.blackmarket:equipped_glove_id())
	if __glove == "molten" then
		self[Idstring("molten"):key()] = true
	else
		self[Idstring("molten"):key()] = nil
	end
end)

function PlayerManager:Is_Glove_Molten()
	if Utils and (Utils:IsInHeist() or Utils:IsInGameState()) then
		return self[Idstring("molten"):key()]
	else
		return false
	end
end