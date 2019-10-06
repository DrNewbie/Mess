if RequiredScript == "lib/managers/menu/stageendscreengui" then
	Hooks:PostHook(StageEndScreenGui, "show", "FasterSkipEventNow", function()
		DelayedCalls:Add('DelayedMod_FasterSkipEventNow', 1, function()
			managers.hud:set_speed_up_endscreen_hud(5)
		end)
	end)
end

if RequiredScript == "lib/managers/hud/hudlootscreen" then
	Hooks:PostHook(HUDLootScreen, "begin_choose_card", "FasterSkipEventChooseCardNow", function(hudd, peer_id, ...)
		if hudd._peer_data and hudd._peer_data[peer_id] then
			hudd._peer_data[peer_id].wait_t = 0
		end
	end )
end