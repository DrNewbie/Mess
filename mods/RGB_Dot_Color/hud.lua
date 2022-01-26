local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "E_"..Idstring("Hook1::"..ThisModIds):key()

Hooks:PostHook(PlayerManager, "update", Hook1, function(self, __t)
	if managers.hud and managers.hud._accessibility_dot_visible then
		local dot_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("accessibility_dot")
		if dot_panel then
			local __red = math.sin(135 * __t) / 2 + 0.5
			local __green = math.sin(140 * __t + 60) / 2 + 0.5
			local __blue = math.sin(145 * __t + 120) / 2 + 0.5
			dot_panel:set_color(Color(__red, __green, __blue, 0))
		end
	end
end)