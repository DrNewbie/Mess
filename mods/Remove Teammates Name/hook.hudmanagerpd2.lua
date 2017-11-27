function HUDManager:set_teammate_name(i)
	self._teammate_panels[i]:set_name(' ')
	for i, data in ipairs(self._hud.name_labels) do
		data.panel:child("text"):set_visible(false)
	end
end