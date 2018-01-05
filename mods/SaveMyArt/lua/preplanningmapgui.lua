_G.SaveMyArt = _G.SaveMyArt or {}

Hooks:PostHook(PrePlanningMapGui, "_draw_point", "DrawAttachEvent", function(self, x, y)
	if not SaveMyArt then
		return
	end
	if SaveMyArt.Read2Put and type(SaveMyArt.Read2Put) == "table" and SaveMyArt.Read2Put[1] then		
		local Read2Put = SaveMyArt.Read2Put
		local peer_id = managers.network:session():local_peer():id()
		SaveMyArt.Read2Put = nil
		for id, data in pairs(Read2Put) do
			local px = (data.x - self._grid_panel:x()) / self._grid_panel:w()
			local py = (data.y - self._grid_panel:y()) / self._grid_panel:h()
			local sync_step = 10000
			px = math.round(px * sync_step) / sync_step
			py = math.round(py * sync_step) / sync_step
			px = math.clamp(px, 0, 1)
			py = math.clamp(py, 0, 1)
			self:set_num_draw_points(self._num_draw_points + 1)
			managers.network:session():send_to_peers_synched("draw_preplanning_point", px, py)
			self:sync_draw_point(peer_id, px, py)
		end
		return
	end
	if self._mouse_moved and SaveMyArt.Start then
		table.insert(SaveMyArt.Current_DATA, {x = x, y = y})
	end
end)