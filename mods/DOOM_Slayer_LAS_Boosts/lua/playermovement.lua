Hooks:PostHook(PlayerMovement, "init", "F_"..Idstring("PostHook:PlayerMovement:init:DewmSlayaLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_DewmSlaya() then
		self._STAMINA_INIT = self._STAMINA_INIT * 10
	end
end)