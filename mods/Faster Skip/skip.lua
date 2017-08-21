if RequiredScript == "lib/managers/menu/stageendscreengui" then
	local StageEndScreenGui_auto_speedup = false
	Hooks:PostHook(StageEndScreenGui, "update", "StageEndScreenGui_update_speedup", function(...)
		if not StageEndScreenGui_auto_speedup then
			StageEndScreenGui_auto_speedup = true
			managers.hud:set_speed_up_endscreen_hud(10)
		end
	end )
end

if RequiredScript == "lib/managers/hud/hudlootscreen" then
	Hooks:PostHook(HUDLootScreen, "begin_choose_card", "HUDLootScreen_begin_choose_card_speedup", function(hudd, peer_id, ...)
		if hudd._peer_data and hudd._peer_data[peer_id] then
			hudd._peer_data[peer_id].wait_t = 0
		end
	end )
end