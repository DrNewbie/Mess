Hooks:PostHook(MissionManager, "init", "ForcedLoadBPH", function(self)
	if not PackageManager:loaded("packages/dlcs/bph/job_bph") then
		PackageManager:load("packages/dlcs/bph/job_bph")
	end
	if not PackageManager:loaded("levels/narratives/locke/bph/world_sounds") then
		PackageManager:load("levels/narratives/locke/bph/world_sounds")
	end
end)