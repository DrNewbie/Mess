if not DB:has(Idstring("movie"), Idstring("movies/hat_in_time/peace_and_tranquility")) then
	return
end

Hooks:PostHook(HUDPlayerCustody, "set_timer_visibility", "HUDCustodyHatTimeSmugDancePlay", function(self, onoff)
	if self._hud_panel:child("hat_kid_smug_dance") then
		self._hud_panel:remove(self._hud_panel:child("hat_kid_smug_dance"))
	end
	if onoff then
		if self._hud_panel:child("hat_kid_smug_dance") then
			self._hud_panel:remove(self._hud_panel:child("hat_kid_smug_dance"))
		end
		local _hat_kid_smug_dance = self._hud_panel:panel({
			valign = "grow",
			name = "hat_kid_smug_dance",
			halign = "grow"
		})
		local _smug_dance_playing = _hat_kid_smug_dance:video({
			name = "smug_dance_playing",
			video = "movies/hat_in_time/peace_and_tranquility",
			width = self._hud_panel:w(),
			height = self._hud_panel:h(),
			loop = true,
			can_skip = true,
			layer = 1000
		})
		_smug_dance_playing:play()
	end
end)