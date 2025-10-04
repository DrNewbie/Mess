local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()
local ThisBannerPath = ThisModPath.."/".."8EB0FC2332700285_50off.dds"	--Artist: https://www.bilibili.com/video/BV1H8h9znEeP/

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local ThisBannerName = __Name(ThisBannerPath)

local dt1 = __Name("dt1")	--current sprite
local dt2 = __Name("dt2")	--moving path
local dt3 = __Name("dt3")	--loop delay

local name1 = __Name("name1")
local panel1 = __Name("panel1")
local bitmap1 = __Name("bitmap1")

local texture_size = {600, 550}

texture_size = {texture_size[1]*0.5, texture_size[2]*0.5}

pcall(
	function ()
		if io.file_is_readable(ThisBannerPath) then
			BLTAssetManager:CreateEntry( 
				ThisBannerName, 
				"texture", 
				ThisBannerPath, 
				nil 
			)
		end
		return
	end
)


Hooks:PostHook(HUDManager, "_player_hud_layout", __Name(1), function(self)
	pcall(function()
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		self[panel1] = self[panel1] or hud and hud.panel or self._ws:panel({name = name1})
		self[panel1]:set_size(texture_size[1], texture_size[2])
		self[bitmap1] = self[panel1]:bitmap({
			texture = ThisBannerName,
			color = Color.white:with_alpha(1),
			layer = 1
		})
		self[dt1] = 1
		self[dt2] = -(texture_size[1] * 1.5)
		self[dt3] = 1
	end)
end)

Hooks:PostHook(HUDManager, "update", __Name(2), function(self, t, dt)
	if self[panel1] and self[bitmap1] then
		if self[dt3] > 0 then
			self[dt3] = self[dt3] - dt
		else
			local __pos = {5, 4, 3, 2, 1, 0, -1, -2, -3, -4}
			self[dt3] = 0.05
			self[bitmap1]:set_center_x(texture_size[1] * __pos[self[dt1]])
			self[dt1] = self[dt1] + 1
			if self[dt1] > 10 then
				self[dt1] = 1
			end
			local fullscreen_ws = managers.menu_component and managers.menu_component._fullscreen_ws
			if fullscreen_ws and alive(fullscreen_ws) and fullscreen_ws.panel and fullscreen_ws:panel() then
				self[dt2] = self[dt2] + 9
				self[panel1]:set_center_x(fullscreen_ws:panel():w()-self[dt2])
				self[panel1]:set_center_y(fullscreen_ws:panel():h()-texture_size[2]*0.5)
				if self[dt2]-texture_size[1]*1.5 > fullscreen_ws:panel():w() then
					self[dt2] = -(texture_size[1] * 1.5)
				end
			end
		end
	end
end)