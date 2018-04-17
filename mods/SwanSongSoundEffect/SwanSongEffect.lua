Hooks:PostHook(HUDManager, "set_teammate_custom_radial", "PlySwanSongSoundEffect", function(self, i, data)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	if hud and hud.panel then
		if data and data.current and data.total then
			if PackageManager:has(Idstring("movie"), Idstring("SwanSongSoundEffect")) then
				if not alive(hud.panel:child("ids_SwanSongSoundEffect")) then
					hud.panel:video({
						name = "ids_SwanSongSoundEffect",
						video = "SwanSongSoundEffect",
						visible = false,
						loop = true,
					}):set_volume_gain(1)
				end
			end
			if data.current <= 0 or data.current/data.total <= 0 then
				if alive(hud.panel:child("ids_SwanSongSoundEffect")) then
					hud.panel:remove(hud.panel:child("ids_SwanSongSoundEffect"))
				end
			end
		end
	end
end)