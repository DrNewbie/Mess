Hooks:PostHook(CharacterTweakData, "_init_civilian", "CharacterTweakData_init_civilian_MMC", function(chara, ...)
	chara.robbers_safehouse = deep_clone(chara.civilian)
end )