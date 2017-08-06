Hooks:PostHook(HUDManager, "set_player_health", "BerserkerEffect_Function", function(...)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	if not hud.panel:child("berserker_left") then
		local berserker_left = hud.panel:bitmap({
			name = "berserker_left",
			visible = false,
			texture = "guis/textures/alphawipe_test",
			layer = 0,
			color = Color(1, 1, 0),
			alpha = 0,
			blend_mode = "add",
			w = hud.panel:w(),
			h = hud.panel:h(),
			x = 0,
			y = 0 
		})
	end
end )