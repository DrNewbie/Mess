Hooks:PostHook(BlackMarketManager, "on_aquired_armor", "Armor8_on_aquired_armor", function(self)	
	self._global.armors["level_8"].unlocked = self._global.armors["level_1"].unlocked
	self._global.armors["level_8"].owned = self._global.armors["level_1"].owned
end)