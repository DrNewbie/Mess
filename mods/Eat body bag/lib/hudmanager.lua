local mod_ids = Idstring("Eat body bag"):key()
local __EBB_main = "F_"..Idstring("EBB_main:"..mod_ids):key()
local __EBB_panel = "F_"..Idstring("EBB_panel:"..mod_ids):key()
local __EBB_bitmap = "F_"..Idstring("__EBB_bitmap:"..mod_ids):key()
local __EBB_text = "F_"..Idstring("__EBB_text:"..mod_ids):key()
local __EBB_e_text = "F_"..Idstring("__EBB_e_text:"..mod_ids):key()
local __EBB_text_rect = "F_"..Idstring("__EBB_text_rect:"..mod_ids):key()
local __EBB_e_location = "F_"..Idstring("__EBB_e_location:"..mod_ids):key()
local __EBB_sout = "F_"..Idstring("__EBB_sout:"..mod_ids):key()
local __EBB_bitmap_visible = "F_"..Idstring("__EBB_bitmap_visible:"..mod_ids):key()

Hooks:PostHook(HUDManager, "_player_hud_layout", "F_"..Idstring("PostHook:HUDManager:_player_hud_layout:"..mod_ids):key(), function(self)
	local EBB_main = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:panel({
		name 	= __EBB_main,
		halign 	= "grow",
		valign 	= "grow"
	})
	self[__EBB_panel] = EBB_main:panel({
		name 	= __EBB_panel,
		visible = false
	})
	self[__EBB_bitmap] = self[__EBB_panel]:bitmap({
		name 			= __EBB_bitmap,
		texture 		= "guis/textures/pd2/healthshield",
		texture_rect 	= {2, 18, 232, 11},
		blend_mode 		= "normal"
	})
	self[__EBB_text_rect] = { 2, 18, 232, 11}
	self[__EBB_sout] = self[__EBB_panel]:bitmap({
		name 			= __EBB_sout,
		texture 		= "guis/textures/pd2/healthshield",
		texture_rect 	= {1, 1, 234, 13},
		blend_mode 		= "normal"
	})
	self[__EBB_text] = self[__EBB_panel]:text({
		name 		= __EBB_text,
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
	self[__EBB_e_text] = self[__EBB_panel]:text({
		name 		= __EBB_e_text,
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
	self[__EBB_e_location] = self[__EBB_panel]:text({
		name 		= __EBB_e_location,
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
	local hx, hy, hw, hh = self[__EBB_text]:text_rect()
	local ex, ey, ew, eh = self[__EBB_e_text]:text_rect()
	local lx, ly, lw, lh = self[__EBB_e_location]:text_rect()
	self[__EBB_text]:set_size(hw, hh)
	self[__EBB_e_text]:set_size(ew, eh)
	self[__EBB_e_location]:set_size(lw, lh)self[__EBB_bitmap]:set_w(self[__EBB_bitmap]:w() - 2)
	self[__EBB_bitmap]:set_center(self[__EBB_panel]:center_x(), self[__EBB_panel]:center_y() - 240)
	self[__EBB_sout]:set_center(self[__EBB_panel]:center_x(), self[__EBB_panel]:center_y() - 240)
	self[__EBB_text]:set_right(self[__EBB_sout]:right())
	self[__EBB_text]:set_bottom(self[__EBB_sout]:top())	
	self[__EBB_e_text]:set_left(self[__EBB_sout]:left())
	self[__EBB_e_text]:set_bottom(self[__EBB_sout]:top())	
	self[__EBB_e_location]:set_center_x(self[__EBB_sout]:center_x())
	self[__EBB_e_location]:set_top(self[__EBB_sout]:bottom())
end)

function HUDManager:set_EBB_visible(visible)	
	if visible == true and not self[__EBB_bitmap_visible] then	
		self[__EBB_bitmap_visible] = true
		self[__EBB_panel]:stop()		
		self[__EBB_panel]:animate(function(p)
			self[__EBB_panel]:set_visible(true)			
			over(0.25, function(o)
				self[__EBB_panel]:set_alpha(math.lerp(self[__EBB_panel]:alpha(), 1, o))
			end)
		end)	
	elseif visible == false and self[__EBB_bitmap_visible] then		
		self[__EBB_bitmap_visible] = nil
		self[__EBB_panel]:stop()		
		self[__EBB_panel]:animate(function(p)
			if self[__EBB_panel]:alpha() >= 0.9 then
				over(0.5, function(o) end)
			end			
			over(1.5, function(o)
				self[__EBB_panel]:set_alpha(math.lerp(self[__EBB_panel]:alpha(), 0, o))
			end)			
			self[__EBB_panel]:set_visible(false)
		end)	
	end
end

function HUDManager:set_EBB(current, total, text)
	if not current or not total then return end
	local _r = current / total
	local r = self[__EBB_bitmap]:width()
	local rn = (self[__EBB_text_rect][3] - 2) * _r
	self[__EBB_e_text]:set_text(text)
	self[__EBB_text]:set_text(string.format("%d/100", _r*100))
	local hx, hy, hw, hh = self[__EBB_text]:text_rect()
	local ex, ey, ew, eh = self[__EBB_e_text]:text_rect()
	self[__EBB_text]:set_size(hw, hh)
	self[__EBB_e_text]:set_size(ew, eh)	
	self[__EBB_text]:set_right(self[__EBB_sout]:right())
	self[__EBB_text]:set_bottom(self[__EBB_sout]:top())
	self[__EBB_e_text]:set_left(self[__EBB_sout]:left())
	self[__EBB_e_text]:set_bottom(self[__EBB_sout]:top())	
	self[__EBB_text]:set_color(current == 0 and Color.red or Color.white)	
	self[__EBB_bitmap]:stop()	
	if rn > r then
		self[__EBB_bitmap]:animate(function(p)
			over(0.5, function(o)
				self[__EBB_bitmap]:set_w(math.lerp(r,rn, o))
				self[__EBB_bitmap]:set_texture_rect(self[__EBB_text_rect][1], self[__EBB_text_rect][2], math.lerp(r, rn, o), self[__EBB_text_rect][4])
			end)
		end)
	end
	self[__EBB_bitmap]:set_w(_r * (self[__EBB_text_rect][3] - 2))
	self[__EBB_bitmap]:set_texture_rect(self[__EBB_text_rect][1], self[__EBB_text_rect][2], self[__EBB_text_rect][3] * _r, self[__EBB_text_rect][4])
end

function HUDManager:set_EBB_rotation(angle)
	self[__EBB_e_location]:set_rotation(angle)
end