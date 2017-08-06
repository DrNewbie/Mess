Hooks:PostHook(MissionManager, "init", "MoreMyCharacter_packages", function(...)
	if not PackageManager:loaded("packages/narr_chill") then
		PackageManager:load("packages/narr_chill")
	end
end )