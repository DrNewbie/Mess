if HUDManager and string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	function HUDManager:__HideDefaultHud()
		for i, _ in pairs(self._teammate_panels) do
			local teammate_panel = self._teammate_panels[i]
			if not teammate_panel or not teammate_panel._panel then
			
			else
				if teammate_panel._panel then
					teammate_panel._panel:set_visible(false)
				end
				if teammate_panel._radial_health_panel then
					teammate_panel._radial_health_panel:set_visible(false)
				end
			end
		end
		return
	end

	Hooks:PostHook(HUDManager, "set_teammate_name", "F_"..Idstring("PostHook:set_teammate_name:HideDefaultHud"):key(), function(self)
		self:__HideDefaultHud()
	end)
	
	Hooks:PostHook(HUDManager, "set_teammate_armor", "F_"..Idstring("PostHook:set_teammate_armor:HideDefaultHud"):key(), function(self)
		self:__HideDefaultHud()
	end)
	
	Hooks:PostHook(HUDManager, "set_teammate_health", "F_"..Idstring("PostHook:set_teammate_health:HideDefaultHud"):key(), function(self)
		self:__HideDefaultHud()
	end)
	
	Hooks:PostHook(HUDManager, "add_teammate_panel", "F_"..Idstring("PostHook:add_teammate_panel:HideDefaultHud"):key(), function(self)
		self:__HideDefaultHud()
	end)
	
	Hooks:PostHook(HUDManager, "_create_teammates_panel", "F_"..Idstring("PostHook:_create_teammates_panel:HideDefaultHud"):key(), function(self)
		self:__HideDefaultHud()
	end)
end

if HUDAssaultCorner and string.lower(RequiredScript) == "lib/managers/hud/hudassaultcorner" then
	Hooks:PostHook(HUDAssaultCorner, "_show_hostages", "F_"..Idstring("PostHook:_show_hostages:HideDefaultHud"):key(), function(self)
		self:_hide_hostages()
	end)
end