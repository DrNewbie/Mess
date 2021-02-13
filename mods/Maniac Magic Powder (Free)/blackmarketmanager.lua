local old_forced_throwable = BlackMarketManager.forced_throwable

function BlackMarketManager:forced_throwable(...)
	if managers.player:has_category_upgrade("player", "cocaine_stacking") then
		return "none"
	end
	return old_forced_throwable(self, ...)
end