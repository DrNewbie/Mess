Hooks:PostHook(PlayerDamage, "init", "F_"..Idstring("PlayerDamage:init:DewmSlayaLASBoosts"):key(), function(self)
	if managers.player:Is_LAS_DewmSlaya() then
		self._HEALTH_INIT = self._HEALTH_INIT * self._lives_init
		self._ARMOR_INIT = self._ARMOR_INIT * self._lives_init
		self._lives_init = 1
		self:band_aid_health()
		self:_regenerate_armor()
	end
end)