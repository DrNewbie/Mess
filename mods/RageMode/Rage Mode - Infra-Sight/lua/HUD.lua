_G.Rage_Special = _G.Rage_Special or {}
Rage_Special_HUD = Rage_Special_HUD or class()
Rage_Special.Rage_Point_Last = 0
Rage_Special.Rage_Point = 0
Rage_Special.Rage_Point_Max = 100
Rage_Special.Activating = false
Rage_Special.Rage_Stop = false
Rage_Special.Activating_Ready_to_End_RUN = false
Rage_Special.Activating_Ready_to_End = 0
Rage_Special.Expire_Time = 0
function Rage_Special_HUD:init(hud)
    self._full_hud = hud
    self.Rage_Special_HUD_panel = self._full_hud:panel({
		visible = false,
        name = "Rage_Special_HUD_panel",
        layer = 100,
        valign = "center", 
        halign = "center",
    })
    self.Rage_Special_HUD_text = self.Rage_Special_HUD_panel:text({
		visible = false,
        name = "Rage_Special_HUD_text",
        vertical = "bottom",
        align = "center",
        text = "0",
        font_size = 48,
        layer = 100,
        color = Color.white,
        font = "fonts/font_large_mf"
    })   
    self.Rage_Special_HUD_panel:rect({
		visible = false,
        name = "Rage_Special_HUD_bg",
        halign = "grow",
        valign = "grow",
        layer = 0,
        color = Color.black
    })     
    local x,y,w,h = self.Rage_Special_HUD_text:text_rect()
    self.Rage_Special_HUD_panel:set_size(w + 6, h + 4)
    self.Rage_Special_HUD_text:set_size(w, h)
    self.Rage_Special_HUD_panel:set_center(self._full_hud:center_x(), self._full_hud:center_y())
end

function Rage_Special_HUD:Update(t)
	if not Utils:IsInHeist() then
		return
	end
	if managers.groupai:state():whisper_mode() then
		self:SetData()
		return
	end
	if not Rage_Special.Rage_Stop and not Rage_Special.Activating and not Rage_Special.Activating_Ready_to_End_RUN then
		Rage_Special.Rage_Point = Rage_Special.Rage_Point + 1
	end
	if Rage_Special.Rage_Stop and Rage_Special.Activating and not Rage_Special.Activating_Ready_to_End_RUN then
		local total_time = 10
		local delta = 0
		if total_time ~= 0 then
			delta = math.clamp((Rage_Special.Expire_Time - Application:time()) / total_time, 0, 1)
		end
		Rage_Special.Rage_Point = math.clamp((Rage_Special.Rage_Point_Max * delta), 0, Rage_Special.Rage_Point_Max)
		local enemies = managers.enemy:all_enemies() or {}
		local _add_or_remove = false
		if Rage_Special.Rage_Point <= 0 then
			Rage_Special.Activating_Ready_to_End_RUN = true
			_add_or_remove = true
		end
		for u_key, u_data in pairs(enemies) do
			if u_data.unit and alive(u_data.unit) then
				if not _add_or_remove then
					u_data.unit:contour():add("mark_enemy", false)
				else
					u_data.unit:contour():remove("mark_enemy", false)
				end
			end
		end
	end
	if Rage_Special.Rage_Point > Rage_Special.Rage_Point_Max and not Rage_Special.Activating then
		Rage_Special.Rage_Point = Rage_Special.Rage_Point_Max
		Rage_Special.Rage_Stop = true
	end
	if (Rage_Special.Activating or Rage_Special.Activating_Ready_to_End_RUN) and Rage_Special.Activating_Ready_to_End == 0 and Rage_Special.Rage_Point <= 0 then
		Rage_Special.Activating_Ready_to_End = t + 30
	end
	if (Rage_Special.Activating or Rage_Special.Activating_Ready_to_End_RUN) and t > Rage_Special.Activating_Ready_to_End and Rage_Special.Activating_Ready_to_End > 0 then
		Rage_Special.Rage_Stop = false
		Rage_Special.Activating = false
		Rage_Special.Activating_Ready_to_End_RUN = false
		Rage_Special.Activating_Ready_to_End = 0
	end
	self:SetData()
end

function Rage_Special_HUD:SetVisible(data)
	self.Rage_Special_HUD_panel:set_visible(data)
	self.Rage_Special_HUD_text:set_visible(data)
end

function Rage_Special_HUD:SetData(data)
	if managers.groupai:state():whisper_mode() then
		self.Rage_Special_HUD_text:set_text("[Rage: Unable]")
	else
		if Rage_Special.Activating_Ready_to_End > 0 then
			self.Rage_Special_HUD_text:set_text("[Rage: Cool Down]")
		elseif Rage_Special.Rage_Stop and not Rage_Special.Activating then
			self.Rage_Special_HUD_text:set_text("[Rage: Ready]")
		elseif Rage_Special.Activating then
			self.Rage_Special_HUD_text:set_text("[Rage: Activating]")
		else
			self.Rage_Special_HUD_text:set_text("[Rage: ".. math.round(Rage_Special.Rage_Point) .."/".. Rage_Special.Rage_Point_Max .."]")
		end
	end
	local x, y, w, h = self.Rage_Special_HUD_text:text_rect()
	self.Rage_Special_HUD_panel:set_size(w + 6,h + 4)
	self.Rage_Special_HUD_text:set_size(w,h)
	self.Rage_Special_HUD_panel:set_center(self._full_hud:center_x()*2 - 150, self._full_hud:center_y())    
	self.Rage_Special_HUD_panel:stop()
end