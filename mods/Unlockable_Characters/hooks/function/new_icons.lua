local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.new_icons then
	return
else
	UnlockableCharactersSys._hooks.new_icons = true
end

local __Name = UnlockableCharactersSys.__Name

Hooks:Add("LocalizationManagerPostInit", UnlockableCharactersSys.__Name("new_icons"), function(...)
	DelayedCalls:Add(UnlockableCharactersSys.__Name("delay_new_icons"), 1, function()
		local names = CriminalsManager.character_names()
		for _, __char_name in pairs(names) do
			__char_name = CriminalsManager.convert_old_to_new_character_workname(tostring(__char_name))
			local __texture = managers.blackmarket:get_character_icon(__char_name) or "guis/textures/pd2/dice_icon"
			tweak_data.hud_icons[__Name("unlock "..__char_name)] = {
				texture = __texture
			}
		end
	end)
end)