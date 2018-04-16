_G.Rage_Special = _G.Rage_Special or {}

Rage_Special_HUD = Rage_Special_HUD or class()

function Rage_Special:Clean()
	self.Rage_Point_Last = 0
	self.Rage_Point = 0
	self.Rage_Point_Max = 100
	self.Rage_Point_Gain = 50
	self.Big_CD = 3
	self.Ready_Time = 10
	self.Activating = false
	self.Rage_Stop = false
	self.Activating_Ready_to_End_RUN = false
	self.Activating_Ready_to_End = 0
	self.Expire_Time = 0
	self.Mark_List = {}
	self.Prepare_To_Stop = 0
	self.Shot_Need_To_Do = 0
	self.Block_SomeThing = false
	self.Block_SomeThing_Time = 0
end

Rage_Special:Clean()

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
		Rage_Special.Rage_Point = Rage_Special.Rage_Point + Rage_Special.Rage_Point_Gain
	end
	if Rage_Special.Rage_Point > Rage_Special.Rage_Point_Max and not Rage_Special.Activating then
		Rage_Special.Rage_Point = Rage_Special.Rage_Point_Max
		Rage_Special.Rage_Stop = true
	end
	if (Rage_Special.Activating or Rage_Special.Activating_Ready_to_End_RUN) and Rage_Special.Activating_Ready_to_End == 0 and Rage_Special.Rage_Point <= 0 then
		Rage_Special.Activating_Ready_to_End = t + Rage_Special.Big_CD
	end
	if (Rage_Special.Activating or Rage_Special.Activating_Ready_to_End_RUN) and t > Rage_Special.Activating_Ready_to_End and Rage_Special.Activating_Ready_to_End > 0 then
		Rage_Special:Clean()
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