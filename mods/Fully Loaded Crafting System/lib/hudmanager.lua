local mod_ids = Idstring("Fully Loaded Crafting System"):key()
local __FLCS_SS_main = "__F_"..Idstring("FLCS_SS_main:"..mod_ids):key()
local __FLCS_SS_panel = "__F_"..Idstring("FLCS_SS_panel:"..mod_ids):key()
local __FLCS_SS_bitmap = "__F_"..Idstring("__FLCS_SS_bitmap:"..mod_ids):key()
local __FLCS_SS_text = "__F_"..Idstring("__FLCS_SS_text:"..mod_ids):key()
local __FLCS_SS_e_text = "__F_"..Idstring("__FLCS_SS_e_text:"..mod_ids):key()
local __FLCS_SS_text_rect = "__F_"..Idstring("__FLCS_SS_text_rect:"..mod_ids):key()
local __FLCS_SS_e_location = "__F_"..Idstring("__FLCS_SS_e_location:"..mod_ids):key()
local __FLCS_SS_sout = "__F_"..Idstring("__FLCS_SS_sout:"..mod_ids):key()
local __FLCS_SS_bitmap_visible = "__F_"..Idstring("__FLCS_SS_bitmap_visible:"..mod_ids):key()

Hooks:PostHook(HUDManager, "_player_hud_layout", "F_"..Idstring("PostHook:HUDManager:_player_hud_layout:"..mod_ids):key(), function(self)
	local FLCS_SS_main = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:panel({
		name 	= __FLCS_SS_main,
		halign 	= "grow",
		valign 	= "grow"
	})
	self[__FLCS_SS_panel] = FLCS_SS_main:panel({
		name 	= __FLCS_SS_panel,
		visible = false
	})
	self[__FLCS_SS_bitmap] = self[__FLCS_SS_panel]:bitmap({
		name 			= __FLCS_SS_bitmap,
		texture 		= "guis/textures/pd2/healthshield",
		texture_rect 	= {2, 18, 232, 11},
		blend_mode 		= "normal"
	})
	self[__FLCS_SS_text_rect] = { 2, 18, 232, 11}
	self[__FLCS_SS_sout] = self[__FLCS_SS_panel]:bitmap({
		name 			= __FLCS_SS_sout,
		texture 		= "guis/textures/pd2/healthshield",
		texture_rect 	= {1, 1, 234, 13},
		blend_mode 		= "normal"
	})
	self[__FLCS_SS_text] = self[__FLCS_SS_panel]:text({
		name 		= __FLCS_SS_text,
		text 		= " ",
		blend_mode 	= "normal",
		alpha 		= 1,
		halign 		= "right",
		font 		= "fonts/font_medium_shadow_mf",
		font_size 	= 20,
		color 		= Color.white,
		align 		= "center",
		layer 		= 1
	})
	self[__FLCS_SS_e_text] = self[__FLCS_SS_panel]:text({
		name 		= __FLCS_SS_e_text,
		text 		= " ",
		blend_mode 	= "normal",
		alpha 		= 1,
		halign 		= "left",
		font 		= "fonts/font_medium_shadow_mf",
		font_size 	= 22,
		color 		= Color.white,
		align 		= "center",
		layer 		= 1
	})
	self[__FLCS_SS_e_location] = self[__FLCS_SS_panel]:text({
		name 		= __FLCS_SS_e_location,
		text 		= " ",
		blend_mode 	= "normal",
		visible 	= false,
		alpha 		= 0.75,
		halign 		= "center",
		font 		= "fonts/font_medium_shadow_mf",
		font_size 	= 20,
		color 		= Color.white,
		align 		= "center",
		layer 		= 1
	})
	local hx, hy, hw, hh = self[__FLCS_SS_text]:text_rect()
	local ex, ey, ew, eh = self[__FLCS_SS_e_text]:text_rect()
	local lx, ly, lw, lh = self[__FLCS_SS_e_location]:text_rect()
	self[__FLCS_SS_text]:set_size(hw, hh)
	self[__FLCS_SS_e_text]:set_size(ew, eh)
	self[__FLCS_SS_e_location]:set_size(lw, lh)self[__FLCS_SS_bitmap]:set_w(self[__FLCS_SS_bitmap]:w() - 2)
	self[__FLCS_SS_bitmap]:set_center(self[__FLCS_SS_panel]:center_x(), self[__FLCS_SS_panel]:center_y() - 240)
	self[__FLCS_SS_sout]:set_center(self[__FLCS_SS_panel]:center_x(), self[__FLCS_SS_panel]:center_y() - 240)
	self[__FLCS_SS_text]:set_right(self[__FLCS_SS_sout]:right())
	self[__FLCS_SS_text]:set_bottom(self[__FLCS_SS_sout]:top())	
	self[__FLCS_SS_e_text]:set_left(self[__FLCS_SS_sout]:left())
	self[__FLCS_SS_e_text]:set_bottom(self[__FLCS_SS_sout]:top())	
	self[__FLCS_SS_e_location]:set_center_x(self[__FLCS_SS_sout]:center_x())
	self[__FLCS_SS_e_location]:set_top(self[__FLCS_SS_sout]:bottom())
end)

function HUDManager:set_FLCS_SS_visible(visible)	
	if visible == true and not self[__FLCS_SS_bitmap_visible] then	
		self[__FLCS_SS_bitmap_visible] = true
		self[__FLCS_SS_panel]:stop()		
		self[__FLCS_SS_panel]:animate(function(p)
			self[__FLCS_SS_panel]:set_visible(true)			
			over(0.25, function(o)
				self[__FLCS_SS_panel]:set_alpha(math.lerp(self[__FLCS_SS_panel]:alpha(), 1, o))
			end)
		end)	
	elseif visible == false and self[__FLCS_SS_bitmap_visible] then		
		self[__FLCS_SS_bitmap_visible] = nil
		self[__FLCS_SS_panel]:stop()		
		self[__FLCS_SS_panel]:animate(function(p)
			if self[__FLCS_SS_panel]:alpha() >= 0.9 then
				over(0.5, function(o) end)
			end			
			over(1.5, function(o)
				self[__FLCS_SS_panel]:set_alpha(math.lerp(self[__FLCS_SS_panel]:alpha(), 0, o))
			end)			
			self[__FLCS_SS_panel]:set_visible(false)
		end)	
	end
end

function HUDManager:set_FLCS_SS(current, total, text)
	if not current or not total then return end
	local _r = current / total
	local r = self[__FLCS_SS_bitmap]:width()
	local rn = (self[__FLCS_SS_text_rect][3] - 2) * _r
	self[__FLCS_SS_e_text]:set_text(text)
	self[__FLCS_SS_text]:set_text(string.format("%d/100", _r*100))
	local hx, hy, hw, hh = self[__FLCS_SS_text]:text_rect()
	local ex, ey, ew, eh = self[__FLCS_SS_e_text]:text_rect()
	self[__FLCS_SS_text]:set_size(hw, hh)
	self[__FLCS_SS_e_text]:set_size(ew, eh)	
	self[__FLCS_SS_text]:set_right(self[__FLCS_SS_sout]:right())
	self[__FLCS_SS_text]:set_bottom(self[__FLCS_SS_sout]:top())
	self[__FLCS_SS_e_text]:set_left(self[__FLCS_SS_sout]:left())
	self[__FLCS_SS_e_text]:set_bottom(self[__FLCS_SS_sout]:top())	
	self[__FLCS_SS_text]:set_color(current == 0 and Color.red or Color.white)	
	self[__FLCS_SS_bitmap]:stop()	
	if rn > r then
		self[__FLCS_SS_bitmap]:animate(function(p)
			over(0.5, function(o)
				self[__FLCS_SS_bitmap]:set_w(math.lerp(r,rn, o))
				self[__FLCS_SS_bitmap]:set_texture_rect(self[__FLCS_SS_text_rect][1], self[__FLCS_SS_text_rect][2], math.lerp(r, rn, o), self[__FLCS_SS_text_rect][4])
			end)
		end)
	end
	self[__FLCS_SS_bitmap]:set_w(_r * (self[__FLCS_SS_text_rect][3] - 2))
	self[__FLCS_SS_bitmap]:set_texture_rect(self[__FLCS_SS_text_rect][1], self[__FLCS_SS_text_rect][2], self[__FLCS_SS_text_rect][3] * _r, self[__FLCS_SS_text_rect][4])
end

function HUDManager:set_FLCS_SS_rotation(angle)
	self[__FLCS_SS_e_location]:set_rotation(angle)
end