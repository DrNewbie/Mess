local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "BO_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

--[[File Path]]
local ThisTexture = "test001.dds"

--[[
	Coding...
	Coding...
	Coding...
]]
local ThisTextureNPath = __Name(ThisTexture)

pcall(function()
	BLTAssetManager:CreateEntry( 
		Idstring(ThisTextureNPath), 
		Idstring("texture"), 
		ThisModPath..ThisTexture, 
		nil 
	)
end)

local is_bool = __Name("is_bool")

if HUDManager and not HUDManager[is_bool] then
	HUDManager[is_bool] = true

	Hooks:PostHook(HUDManager, "_player_hud_layout", __Name("_player_hud_layout"), function(self)
		local name1 = __Name("name1")
		local panel1 = __Name("panel1")
		local bitmap1 = __Name("bitmap1")
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		self[panel1] = self[panel1] or hud and hud.panel or self._ws:panel({name = name1})
		self[bitmap1] = self[panel1]:bitmap({
			texture = ThisTextureNPath,
			color = Color.white:with_alpha(1),
			alpha = 1,
			layer = 1
		})
		self[bitmap1]:set_size(self[panel1]:w()*1.01666666, self[panel1]:h()*1.01666666)
		self[bitmap1]:set_center(self[panel1]:center())
		self[bitmap1]:set_visible(true)
	end)
end