LegendaryArmours = LegendaryArmours or {}

Hooks:PostHook(PlayerManager, "init_finalize", "F_"..Idstring("PostHook:PlayerManager:init_finalize:DewmSlayaLASBoosts"):key(), function(self)
	local las = tostring(managers.blackmarket:equipped_player_style())
	if las == "las_dewmslaya" then
		self._is_dewmslaya = true
	else
		self._is_dewmslaya = nil
	end
end)

function PlayerManager:Is_LAS_DewmSlaya()
	if Utils and (Utils:IsInHeist() or Utils:IsInGameState()) then
		return self._is_dewmslaya
	else
		return false
	end
end