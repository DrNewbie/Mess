local SentryGunModeFUN_ModPath = ModPath

Hooks:Add('LocalizationManagerPostInit', 'SentryGunModeFUN_Loc', function(self)
	self:load_localization_file(SentryGunModeFUN_ModPath..'Loc/EN.json', false)
end)