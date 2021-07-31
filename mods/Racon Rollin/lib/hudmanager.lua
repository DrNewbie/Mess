local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local hook1 = "H_"..Idstring("hook1::"..mod_ids):key()
local hook2 = "H_"..Idstring("hook2::"..mod_ids):key()
local dt1 = "DT_"..Idstring("dt1::"..mod_ids):key()
local name1 = "V_"..Idstring("name1::"..mod_ids):key()
local panel1 = "V_"..Idstring("panel1::"..mod_ids):key()
local bitmap1 = "V_"..Idstring("bitmap1::"..mod_ids):key()
local texture_size = {256, 256}

Hooks:PostHook(HUDManager, "_player_hud_layout", hook1, function(self)
	local p_load = "packages/memes_rollin001"
	if PackageManager:package_exists(p_load) then
		if PackageManager:loaded(p_load) then
			PackageManager:unload(p_load)
		end
		PackageManager:load(p_load)
	end	
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	self[panel1] = self[panel1] or hud and hud.panel or self._ws:panel({name = name1})
	self[panel1]:set_size(texture_size[1], texture_size[2])
	self[bitmap1] = self[panel1]:bitmap({
		texture = "textures/memes/rollin001",
		color = Color.white:with_alpha(1),
		layer = 1
	})
	self[dt1] = 1
end)

Hooks:PostHook(HUDManager, "update", hook2, function(self, t, dt)
	if self[panel1] and self[bitmap1] then
		local __image_list = {
			--1~5
			{2, 2},
			{1, 2},
			{0, 2},
			{-1, 2},
			{-2, 2},
			--6~10
			{2, 1},
			{1, 1},
			{0, 1},
			{-1, 1},
			{-2, 1},
			--11~15
			{2, 0},
			{1, 0},
			{0, 0},
			{-1, 0},
			{-2, 0},
			--16~20
			{2, -1},
			{1, -1},
			{0, -1},
			{-1, -1},
			{-2, -1}
		}
		local x_new = texture_size[1] * __image_list[self[dt1]][1] + (texture_size[1] * 0.5)
		local y_new = texture_size[1] * __image_list[self[dt1]][2]
		self[bitmap1]:set_center(x_new, y_new)
		self[dt1] = self[dt1] + 1
		if self[dt1] > #__image_list then
			self[dt1] = 1
		end
	end
end)