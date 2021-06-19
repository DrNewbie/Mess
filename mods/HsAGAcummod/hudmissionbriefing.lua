_G.HsAGA = _G.HsAGA or {}

Hooks:PostHook(HUDMissionBriefing, "init", "HsAGA_"..Idstring("Post:MissionManager:init"):key(), function()
	if HsAGA and HsAGA.ModPath then
		DelayedCalls:Add("HsAGA_LoadMeTrue_Delay", 0.1, function()
			HsAGA:Apply_CFG(true)
		end)
		DelayedCalls:Add("HsAGA_LoadMeFalse_Delay", 1, function()
			HsAGA:Apply_CFG(false)
		end)
	end
end)