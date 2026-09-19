local ThisModPath = tostring(ModPath)

if not Steam:is_product_owned("414740") then
	return
end

local __Name = function(__data)
	return "GT_"..Idstring(ThisModPath..string.format("%q", __data)):key()
end

Hooks:PostHook(WeaponTweakData, "_init_ching", __Name(1), function(self, ...)
	pcall(function()
		if type(self.ching.stats_modifiers) == "table" and self.ching.stats_modifiers.damage then
			self.ching.stats_modifiers.damage = self.ching.stats_modifiers.damage * 1.10
		else
			self.ching.stats_modifiers = {damage = 1.10}
		end
		self.ching.has_description = true
	end)
end)

DelayedCalls:Add(__Name(2), 0.1, function()
	pcall(function()
		local old_desc = managers.localization:text(tweak_data.weapon.ching.desc_id)
		local new_desc = "This weapon damage is buffed by 10% due to owning [Raid: World War II]."
		managers.localization:add_localized_strings({
			[tweak_data.weapon.ching.desc_id] = new_desc
		})
	end)
end)