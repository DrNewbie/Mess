local CriticalPerk_can_be_critical = CopDamage.can_be_critical

function CopDamage:can_be_critical(...)
	if managers.player:has_category_upgrade("player", "passive_critical_to_all") then
		return true
	end
	return CriticalPerk_can_be_critical(self, ...)
end