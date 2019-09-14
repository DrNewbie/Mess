Hooks:PostHook(HUDManager, "_player_hud_layout", "GflHoxyCharmAnimeInit", function(self)
	local p_load = "packages/gfl_hoxy_charm_anime"
	if PackageManager:package_exists(p_load) then
		if PackageManager:loaded(p_load) then
			PackageManager:unload(p_load)
		end
		PackageManager:load(p_load)
	end	
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	self._a_hoxy_charm_panel = self._a_hoxy_charm_panel or hud and hud.panel or self._ws:panel({ name = "HoxyDanceAnime" })
	self._a_hoxy_charm_panel:set_size(396, 231)
	self._a_hoxy_charm_img = self._a_hoxy_charm_panel:bitmap({
		texture = "textures/gfl/hoxy_charm",
		color = Color.white:with_alpha(1),
		blend_mode = "add",
		layer = 1
	})
	self._hoxy_charm_it = 1
end)

Hooks:PostHook(HUDManager, "update", "GflHoxyCharmAnimeInitLoop", function(self)
	if self._a_hoxy_charm_panel and self._a_hoxy_charm_img then
		local hox_lis = {
			--1~10
			{5, 2},
			{4, 2},
			{3, 2},
			{2, 2},
			{1, 2},
			{0, 2},
			{-1, 2},
			{-2, 2},
			{-3, 2},
			{-4, 2},
			--11~20
			{5, 1},
			{4, 1},
			{3, 1},
			{2, 1},
			{1, 1},
			{0, 1},
			{-1, 1},
			{-2, 1},
			{-3, 1},
			{-4, 1},
			--21~30
			{5, 0},
			{4, 0},
			{3, 0},
			{2, 0},
			{1, 0},
			{0, 0},
			{-1, 0},
			{-2, 0},
			{-3, 0},
			{-4, 0},
			--31~35
			{5, -1},
			{4, -1},
			{3, -1},
			{2, -1},
			{1, -1}
		}
		local x_new = 396 * hox_lis[self._hoxy_charm_it][1]
		local y_new = 231 * hox_lis[self._hoxy_charm_it][2]
		self._a_hoxy_charm_img:set_center(x_new, y_new)
		self._hoxy_charm_it = self._hoxy_charm_it + 1
		if self._hoxy_charm_it > #hox_lis then
			self._hoxy_charm_it = 1
		end
	end
end)