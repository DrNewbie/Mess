Hooks:PostHook(HUDTeammate, 'set_health', 'Post_set_health_chanage_colour', function(self, data)
	if self._main_player and data.current and data.total then
		local radial_health_panel = self._radial_health_panel
		local radial_health = radial_health_panel:child("radial_health")
		local ratio = data.current / data.total
		if 0.25 > ratio then
			radial_health:set_image("guis/textures/pd2/hud_health_alt_025")
		elseif 0.50 > ratio then
			radial_health:set_image("guis/textures/pd2/hud_health_alt_050")
		elseif 0.75 > ratio then
			radial_health:set_image("guis/textures/pd2/hud_health_alt_075")
		elseif 0.90 > ratio then
			radial_health:set_image("guis/textures/pd2/hud_health_alt_090")
		else
			radial_health:set_image("guis/textures/pd2/hud_health")
		end
	end
end)