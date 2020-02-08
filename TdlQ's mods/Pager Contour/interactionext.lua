local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pc_original_intimitateinteractionext_syncinteracted = IntimitateInteractionExt.sync_interacted
function IntimitateInteractionExt:sync_interacted(peer, player, status, ...)
	local td = self.tweak_data

	pc_original_intimitateinteractionext_syncinteracted(self, peer, player, status, ...)

	if td == 'corpse_alarm_pager' then
		if status == 'started' or status == 1 then
			self._unit:contour():remove('generic_interactable')
			self._unit:contour():add('friendly', nil, nil)
		elseif status == 'complete' or status == 3 then
			self._unit:contour():remove('friendly')
		end
	end
end
