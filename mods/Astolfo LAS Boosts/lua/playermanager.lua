LegendaryArmours = LegendaryArmours or {}

Hooks:PostHook(PlayerManager, "init_finalize", "F_"..Idstring("PostHook:PlayerManager:init_finalize:AstolfoLASBoosts"):key(), function(self)
	local las = tostring(managers.blackmarket:equipped_armor_skin())
	if LegendaryArmours[las] and las == "grandcutie" then
		self._is_grandcutie = true
	else
		self._is_grandcutie = nil
	end
end)

function PlayerManager:Is_LAS_Grandcutie()
	if Utils and (Utils:IsInHeist() or Utils:IsInGameState()) then
		return self._is_grandcutie
	else
		return false
	end
end