local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_copbrain_onintimidated = CopBrain.on_intimidated
function CopBrain:on_intimidated(amount, aggressor_unit)
	if aggressor_unit and self._unit:base().pgt_is_being_moved == aggressor_unit then
		return
	end

	return pgt_original_copbrain_onintimidated(self, amount, aggressor_unit)
end

local pgt_original_copbrain_searchforcoarsepath = CopBrain.search_for_coarse_path
function CopBrain:search_for_coarse_path(search_id, to_seg, verify_clbk, access_neg)
	local pgt_destination = self._unit:base().pgt_destination
	if pgt_destination then
		to_seg = managers.navigation:get_nav_seg_from_pos(pgt_destination, true)
		verify_clbk = nil
	end
	return pgt_original_copbrain_searchforcoarsepath(self, search_id, to_seg, verify_clbk, access_neg)
end
