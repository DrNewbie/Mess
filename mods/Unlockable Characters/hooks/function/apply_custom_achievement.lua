local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.apply_custom_achievement then
	return
else
	UnlockableCharactersSys._hooks.apply_custom_achievement = true
end

Hooks:Add("LocalizationManagerPostInit", UnlockableCharactersSys.__Name("apply_custom_achievement"), function(...)
	DelayedCalls:Add(UnlockableCharactersSys.__Name("delay_apply_custom_achievement"), 1, function()
		UnlockableCharactersSys._funcs.__CustomAchievement()
	end)
end)