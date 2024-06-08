local ThisModPath = tostring(ModPath or os.time())

local __Name = function(__id)
	return "CCC_"..Idstring(string.format("	%q	w	%q	", tostring(__id), ThisModPath)):key()
end

pcall(function()
	DelayedCalls:Add(__Name("delay load this mod"), 1, function()
		if ChaosModifier then
			ChaosMod:load_modifiers(ThisModPath .. "req/modifiers/")
		end
	end)
	Hooks:Add("LocalizationManagerPostInit", __Name("load loc file"), function(self)
		self:load_localization_file(ThisModPath .. "loc/english_low_stamina.txt")
	end)
end)