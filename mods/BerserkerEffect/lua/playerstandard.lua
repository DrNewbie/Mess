BerserkerEffectBool = 0
BerserkerEffectHealthLast = 0

Hooks:PostHook(PlayerStandard, "update", "BerserkerEffect_Update", function(self, t, dt)
	local _health_ratio = self._ext_damage:health_ratio() or 0
	if _health_ratio > 0 and _health_ratio < 0.5 and managers.player:has_category_upgrade("player", "melee_damage_health_ratio_multiplier") then
		BerserkerEffectBool = math.clamp(_health_ratio*1.3, 0.01, 0.99)
	else
		BerserkerEffectBool = 0
	end
	if BerserkerEffectHealthLast == _health_ratio then
		return
	end
	BerserkerEffectHealthLast = _health_ratio
	if not managers.hud then
		return
	end
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	if not hud then
		return
	end
	local berserker_left = hud.panel:child("berserker_left")
	if BerserkerEffectBool > 0 and berserker_left then
		berserker_left:set_visible(true)
		local hudinfo = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
		berserker_left:animate(hudinfo.flash_icon, 4000000000)
		berserker_left:set_color((Color(1, BerserkerEffectBool, 0)))
		berserker_left:set_alpha(1 - BerserkerEffectBool*1.2)
	elseif hud.panel:child("berserker_left") then
		berserker_left:stop()
		berserker_left:set_visible(false)
	end
	if berserker_left and BerserkerEffectBool <= 0 then
		berserker_left:set_visible(false)
	end
end )