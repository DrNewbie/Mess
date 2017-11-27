local Remove_upd_color = ContourExt._upd_color

function ContourExt:_upd_color(...)
	if self._contour_list and self._contour_list[1] and tostring(self._contour_list[1].type) == 'teammate' then
		return
	end
	Remove_upd_color(self, ...)
end

local Remove_upd_opacity = ContourExt._upd_opacity

function ContourExt:_upd_opacity(...)
	if self._contour_list and self._contour_list[1] and tostring(self._contour_list[1].type) == 'teammate' then
		return
	end
	Remove_upd_opacity(self, ...)
end