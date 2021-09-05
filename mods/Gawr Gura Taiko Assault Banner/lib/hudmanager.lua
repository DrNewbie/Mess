local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local hook1 = "H_"..Idstring("hook1::"..mod_ids):key()
local hook2 = "H_"..Idstring("hook2::"..mod_ids):key()
local dt1 = "DT_"..Idstring("dt1::"..mod_ids):key()
local dt2 = "DT_"..Idstring("dt2::"..mod_ids):key()
local dt3 = "DT_"..Idstring("dt3::"..mod_ids):key()
local bool1 = "V_"..Idstring("bool1::"..mod_ids):key()
local bool2 = "V_"..Idstring("bool2::"..mod_ids):key()
local name1 = "V_"..Idstring("name1::"..mod_ids):key()
local panel1 = "V_"..Idstring("panel1::"..mod_ids):key()
local bitmap1 = "V_"..Idstring("bitmap1::"..mod_ids):key()
local texture_size = {256, 256}

Hooks:PostHook(HUDManager, "_player_hud_layout", hook1, function(self)
	local p_load = "packages/gura_taiko_small"
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
		texture = "textures/memes/gura_taiko_small",
		color = Color.white:with_alpha(1),
		layer = 1
	})
	self[dt1] = 1
	self[dt2] = -(texture_size[1] * 1.25)
	self[dt3] = 1
	self[bool1] = false
	self[bool2] = false
	if self._hud_assault_corner and managers.groupai:state():get_assault_mode() then
		self[bool1] = managers.groupai:state():get_assault_mode()
	end
	self[panel1]:set_visible(false)
	self[bitmap1]:set_visible(false)
end)

Hooks:PostHook(HUDManager, "update", hook2, function(self, t, dt)
	if self[panel1] and self[bitmap1] then
		if self._hud_assault_corner then
			if self[bool1] ~= managers.groupai:state():get_assault_mode() then
				self[bool1] = managers.groupai:state():get_assault_mode()
				self[dt2] = -(texture_size[1] * 1.25)
				self[panel1]:set_center_x(-1000)
				if self[bool1] then
					self[panel1]:set_visible(true)
					self[bitmap1]:set_visible(true)
				else
					self[bool2] = true
					self[bool1] = false
				end
			end
		else
			self[bool1] = false
			self[panel1]:set_visible(false)
			self[bitmap1]:set_visible(false)
		end
		if self[bool1] or self[bool2] then
			if not self[bool2] and self[dt3] > 0 then
				self[dt3] = self[dt3] - dt
			else
				self[dt3] = 0.05
				local __image_list = {
					--1~4
					{2, 1},
					{1, 1},
					{0, 1},
					{-1, 1},
					--4~8
					{2, 0},
					{1, 0},
					{0, 0},
					{-1, 0}
				}
				local x_new = texture_size[1] * __image_list[self[dt1]][1]
				local y_new = texture_size[1] * __image_list[self[dt1]][2]
				self[bitmap1]:set_center(x_new, y_new)
				self[dt1] = self[dt1] + 1
				if self[dt1] > #__image_list then
					self[dt1] = 1
				end
				local fullscreen_ws = managers.menu_component and managers.menu_component._fullscreen_ws
				if fullscreen_ws and alive(fullscreen_ws) and fullscreen_ws.panel and fullscreen_ws:panel() then
					self[dt2] = self[dt2] + 3
					self[panel1]:set_center_x(fullscreen_ws:panel():w()-self[dt2])
					if self[dt2]-texture_size[1]*1.25 > fullscreen_ws:panel():w() then
						self[dt2] = -(texture_size[1] * 1.25)
						if self[bool2] then
							self[bool2] = false
							self[panel1]:set_visible(false)
							self[bitmap1]:set_visible(false)
						end
					end
				end
			end
		end
	end
end)