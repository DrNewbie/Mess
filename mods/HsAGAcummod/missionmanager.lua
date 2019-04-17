_G.HsAGA = _G.HsAGA or {}

Hooks:PostHook(MissionManager, "init", "HsAGA_"..Idstring("Post:MissionManager:init"):key(), function()
	if HsAGA and HsAGA.ModPath then
		HsAGA:Apply_CFG(true)
		HsAGA:Apply_CFG(false)
	end
end)