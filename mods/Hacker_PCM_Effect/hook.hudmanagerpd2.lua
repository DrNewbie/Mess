local LoadThisTextureFile = 'gui/this_hacker_pcm_effect'

Hooks:PostHook(HUDManager, "activate_teammate_ability_radial", "F_"..Idstring("PostHook::Hacker PCM Effect"):key(), function(self, __i, __time_left, __time_total)
	if type(__i) == type(HUDManager.PLAYER_PANEL) and __i == HUDManager.PLAYER_PANEL and type(__time_left) == "number" then
		local __texture = DB:has('texture', LoadThisTextureFile) and LoadThisTextureFile or "guis/textures/alphawipe_test"
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		if not hud.panel:child("__hacker_pcm_effect") then
			local __hacker_pcm_effect = hud.panel:bitmap({
				name = "__hacker_pcm_effect",
				visible = false,
				texture = __texture,
				layer = 0,
				color = Color(0.8, 0.8, 0.8),
				blend_mode = "add",
				w = hud.panel:w(),
				h = hud.panel:h(),
				x = 0,
				y = 0 
			})
		end
		local __hacker_pcm_effect = hud.panel:child("__hacker_pcm_effect")
		if __hacker_pcm_effect then
			local hudinfo = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
			local function anim(o)
				__hacker_pcm_effect:set_visible(true)
				over(__time_left, function (p)
				
				end)
				__hacker_pcm_effect:stop()
				__hacker_pcm_effect:set_visible(false)
			end
			__hacker_pcm_effect:stop()
			__hacker_pcm_effect:animate(hudinfo.flash_icon, __time_left)
			__hacker_pcm_effect:animate(anim)
		end
	end
end)