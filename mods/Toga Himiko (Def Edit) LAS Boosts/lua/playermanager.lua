LegendaryArmours = LegendaryArmours or {}

Hooks:PostHook(PlayerManager, "init_finalize", "F_"..Idstring("PostHook:PlayerManager:init_finalize:Toga Himiko (The Definitive Edition) [LAS] Boosts"):key(), function(self)
	local las = tostring(managers.blackmarket:equipped_player_style())
	if las == "las_gt" or las == "las_gt_gear" then
		self._is_toga_himiko_new = true
	else
		self._is_toga_himiko_new = nil
	end
end)

function PlayerManager:Is_LAS_TogaHimikoNew()
	if Utils and (Utils:IsInHeist() or Utils:IsInGameState()) then
		return self._is_toga_himiko_new
	else
		return false
	end
end