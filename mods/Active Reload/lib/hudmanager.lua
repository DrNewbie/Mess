Hooks:PostHook(HUDManager, "_player_hud_layout", "ActiveReloadManagerPlayerInfoHUDLayout", function(self)
	local active_reload_main = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:panel({
		name 	= "active_reload_main",
		halign 	= "grow",
		valign 	= "grow"
	})
	self._active_reload_panel = active_reload_main:panel({
		name 	= "active_reload_panel",
		visible = false
	})
	self._active_reload = self._active_reload_panel:bitmap({
		name 			= "unit_health",
		texture 		= "guis/textures/pd2/healthshield",
		texture_rect 	= {
							2,
							18,
							232,
							11
						},
		blend_mode 		= "normal"
	})
	self._health_text_rect = { 2, 18, 232, 11 }
	self._active_reload_shield = self._active_reload_panel:bitmap({
		name 			= "active_reload_shield",
		texture 		= "guis/textures/pd2/healthshield",
		texture_rect 	= {
							1,
							1,
							234,
							13
						},
		blend_mode 		= "normal"
	})
	self._active_reload_text = self._active_reload_panel:text({
		name 		= "active_reload_text",
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
	self._active_reload_enemy_text = self._active_reload_panel:text({
		name 		= "active_reload_enemy_text",
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
	self._active_reload_enemy_location = self._active_reload_panel:text({
		name 		= "active_reload_enemy_location",
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
	local hx, hy, hw, hh = self._active_reload_text:text_rect()
	local ex, ey, ew, eh = self._active_reload_enemy_text:text_rect()
	local lx, ly, lw, lh = self._active_reload_enemy_location:text_rect()
	self._active_reload_text:set_size(hw, hh)
	self._active_reload_enemy_text:set_size(ew, eh)
	self._active_reload_enemy_location:set_size(lw, lh)self._active_reload:set_w(self._active_reload:w() - 2)
	self._active_reload:set_center(self._active_reload_panel:center_x(), self._active_reload_panel:center_y() - 240)
	self._active_reload_shield:set_center(self._active_reload_panel:center_x(), self._active_reload_panel:center_y() - 240)
	self._active_reload_text:set_right(self._active_reload_shield:right())
	self._active_reload_text:set_bottom(self._active_reload_shield:top())	
	self._active_reload_enemy_text:set_left(self._active_reload_shield:left())
	self._active_reload_enemy_text:set_bottom(self._active_reload_shield:top())	
	self._active_reload_enemy_location:set_center_x(self._active_reload_shield:center_x())
	self._active_reload_enemy_location:set_top(self._active_reload_shield:bottom())
end)

function HUDManager:set_active_reload_visible(visible)	
	if visible == true and not self._active_reload_visible then	
		self._active_reload_visible = true
		self._active_reload_panel:stop()		
		self._active_reload_panel:animate(function(p)
			self._active_reload_panel:set_visible(true)			
			over(0.25, function(o)
				self._active_reload_panel:set_alpha(math.lerp(self._active_reload_panel:alpha(), 1, o))
			end)
		end)	
	elseif visible == false and self._active_reload_visible then		
		self._active_reload_visible = nil
		self._active_reload_panel:stop()		
		self._active_reload_panel:animate(function(p)
			if self._active_reload_panel:alpha() >= 0.9 then
				over(0.5, function(o) end)
			end			
			over(1.5, function(o)
				self._active_reload_panel:set_alpha(math.lerp(self._active_reload_panel:alpha(), 0, o))
			end)			
			self._active_reload_panel:set_visible(false)
		end)	
	end
end

function HUDManager:set_active_reload(current, total, text)
	if not current or not total then return end
	local _r = current / total
	local r = self._active_reload:width()
	local rn = (self._health_text_rect[3] - 2) * _r
	self._active_reload_enemy_text:set_text(text)
	self._active_reload_text:set_text(string.format("%d/100", _r*100))
	local hx, hy, hw, hh = self._active_reload_text:text_rect()
	local ex, ey, ew, eh = self._active_reload_enemy_text:text_rect()
	self._active_reload_text:set_size(hw, hh)
	self._active_reload_enemy_text:set_size(ew, eh)	
	self._active_reload_text:set_right(self._active_reload_shield:right())
	self._active_reload_text:set_bottom(self._active_reload_shield:top())
	self._active_reload_enemy_text:set_left(self._active_reload_shield:left())
	self._active_reload_enemy_text:set_bottom(self._active_reload_shield:top())	
	self._active_reload_text:set_color(current == 0 and Color.red or Color.white)	
	self._active_reload:stop()	
	if rn > r then
		self._active_reload:animate(function(p)
			over(0.5, function(o)
				self._active_reload:set_w(math.lerp(r,rn, o))
				self._active_reload:set_texture_rect(self._health_text_rect[1], self._health_text_rect[2], math.lerp(r, rn, o), self._health_text_rect[4])
			end)
		end)
	end
	self._active_reload:set_w(_r * (self._health_text_rect[3] - 2))
	self._active_reload:set_texture_rect(self._health_text_rect[1], self._health_text_rect[2], self._health_text_rect[3] * _r, self._health_text_rect[4])
end

function HUDManager:set_active_reload_rotation(angle)
	self._active_reload_enemy_location:set_rotation(angle)
end