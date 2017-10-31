if Network:is_client() then
	return
end

_G.SurvivorModeBase = _G.SurvivorModeBase or {}

_Net = _G and _G.LuaNetworking or nil

function HUDManager:Announce_Now_Wave(wave)
	DelayedCalls:Add( "DelayedCallsExample", 10, function()
		managers.hud:show_hint({text = "Wave: [".. wave .."]"})
	end )
	SurvivorModeBase:Sync_Send("Sync_Announce_Now_Wave", wave)
end
