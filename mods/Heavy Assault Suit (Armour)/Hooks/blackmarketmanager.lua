Hooks:PostHook(BlackMarketManager, "on_aquired_armor", "Dr_Newbie_CustomArmourPackage_on_aquired_armor", function(self)	
	self._global.armors["level_9"].unlocked = self._global.armors["level_7"].unlocked
	self._global.armors["level_9"].owned = self._global.armors["level_7"].owned
end)