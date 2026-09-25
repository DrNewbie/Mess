local ThisModPath = tostring(ModPath)

local ThisModIds = Idstring(ThisModPath):key()

_G.AddAddonInfoToHUD = _G.AddAddonInfoToHUD or {}

if _G.AddAddonInfoToHUD.ThisModPath then
	return
end

_G.AddAddonInfoToHUD.ThisModPath = ThisModPath

_G.AddAddonInfoToHUD.ThisModIds = ThisModIds

_G.AddAddonInfoToHUD.All_of_Addon = {}

_G.AddAddonInfoToHUD.__Name = function(__id)
	return "T_"..Idstring(tostring(__id).."::".._G.AddAddonInfoToHUD.ThisModIds):key()
end

_G.AddAddonInfoToHUD.__log = function(...)
	pcall(log, ("[Addon Info]\t"..table.concat({...}, "\t")))
end

local __Name = _G.AddAddonInfoToHUD.__Name

local __log = _G.AddAddonInfoToHUD.__log

_G.AddAddonInfoToHUD.__default = {
	this_hud_panel_data = {
		w = 200,
		h = 100,
		center_x = 0.75,
		center_y = 1.05
	},
	
	this_hud_box_data = {
		w = 88,
		h = 64	
	},
	
	this_hud_box_text_data = {
		text = "0",
		valign = "center",
		align = "center",
		vertical = "center",
		w = 88,
		h = 64,
		layer = 1,
		color = Color.white,
		font = "fonts/font_large_mf",
		font_size = 24
	},
	
	this_hud_box_icon_data = {
		texture = "guis/textures/pd2/mouse_buttons",
		texture_rect = {
			1,
			1,
			17,
			23
		},
		valign = "top",
		layer = 1,
		w = 64,
		h = 64
	}
}

_G.AddAddonInfoToHUD.Init = function(__data)
	if not managers.hud or not PlayerBase.PLAYER_INFO_HUD_PD2 then
		__log("not managers.hud or not PlayerBase.PLAYER_INFO_HUD_PD2")
		return
	end
	
	local main_hud_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel
	
	local this_hud_panel_data = __data.this_hud_panel_data
	local this_hud_box_data = __data.this_hud_box_data
	local this_hud_box_text_data = __data.this_hud_box_text_data
	local this_hud_box_icon_data = __data.this_hud_box_icon_data
	
	if type(this_hud_panel_data.name) ~= "string" then
		this_hud_panel_data.name = __Name(math.random())
	end
	if type(this_hud_box_data.name) ~= "string" then
		this_hud_box_data.name = __Name(math.random()*10)
	end
	if type(this_hud_box_text_data.name) ~= "string" then
		this_hud_box_text_data.name = __Name(math.random()*100)
	end
	if type(this_hud_box_icon_data.name) ~= "string" then
		this_hud_box_icon_data.name = __Name(math.random()*1000)
	end
	
	--[[
		this_hud_panel init
	]]

	local this_hud_panel = main_hud_panel:panel({
		name = this_hud_panel_data.name,
		alpha =	1,
		visible = false,
		w = this_hud_panel_data.w,
		h = this_hud_panel_data.h
	})
	
	this_hud_panel:set_center(main_hud_panel:center())
	this_hud_panel:set_center_x(main_hud_panel:center_x() * this_hud_panel_data.center_x)
	this_hud_panel:set_center_y(main_hud_panel:center_y() * this_hud_panel_data.center_y)
	
	__log("this_hud_panel init:", this_hud_panel_data.name)

	--[[
		this_hud_box init
	]]
	
	local this_hud_box = HUDBGBox_create(this_hud_panel, {w = this_hud_box_data.w, h = this_hud_box_data.h}, {})
	
	__log("this_hud_box init:", this_hud_box_data.name)

	--[[
		this_hud_box_text init
	]]

	local this_hud_box_text = this_hud_box:text({
		name = this_hud_box_text_data.name,
		text = this_hud_box_text_data.text,
		valign = this_hud_box_text_data.valign,
		align = this_hud_box_text_data.align,
		vertical = this_hud_box_text_data.vertical,
		w = this_hud_box_text_data.w,
		h = this_hud_box_text_data.h,
		layer = this_hud_box_text_data.layer,
		color = this_hud_box_text_data.color,
		font = this_hud_box_text_data.font,
		font_size = this_hud_box_text_data.font_size
	})
	
	__log("this_hud_box_text init:", this_hud_box_text_data.name)
	
	--[[
		this_hud_box_icon init
	]]
	
	if not DB:has(Idstring("texture"), Idstring(this_hud_box_icon_data.texture)) then
		__log("not DB:has", this_hud_box_icon_data.texture)
	else
		__log("DB:has", this_hud_box_icon_data.texture)
	end
	
	local this_hud_box_icon = this_hud_panel:bitmap({
		name = this_hud_box_icon_data.name,
		texture = this_hud_box_icon_data.texture,
		texture_rect = this_hud_box_icon_data.texture_rect,
		valign = this_hud_box_icon_data.valign,
		layer = this_hud_box_icon_data.layer,
		w = this_hud_box_icon_data.w,
		h = this_hud_box_icon_data.h
	})
	
	this_hud_box_icon:set_right(this_hud_box:parent():w())
	this_hud_box_icon:set_center_y(this_hud_box:h() / 2)
	this_hud_box:set_right(this_hud_box_icon:left())
	
	__log("this_hud_box_icon init:", this_hud_box_icon_data.name)
	
	this_hud_panel:set_visible(true)
	
	_G.AddAddonInfoToHUD.All_of_Addon[this_hud_panel_data.name] = {
		this_hud_panel = this_hud_panel, 
		this_hud_box = this_hud_box, 
		this_hud_box_text = this_hud_box_text, 
		this_hud_box_icon = this_hud_box_icon	
	}
	
	return this_hud_panel, this_hud_box, this_hud_box_text, this_hud_box_icon
end