function GenericDLCManager:is_dlc_unlocked(dlc)
	if dlc == 'nonbeardlib' then
		return false
	end
	return tweak_data.dlc[dlc] and tweak_data.dlc[dlc].free or self:has_dlc(dlc)
end