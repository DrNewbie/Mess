Hooks:PostHook(BlackMarketManager, "on_aquired_armor", "F_"..Idstring("Heavy Assault Suit (Armour):1"):key(), function(self)	
	self._global.armors["level_9"].unlocked = self._global.armors["level_7"].unlocked
	self._global.armors["level_9"].owned = self._global.armors["level_7"].owned
end)