local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_huskcopbrain_clbkdeath = HuskCopBrain.clbk_death
function HuskCopBrain:clbk_death(my_unit, damage_info)
	if self._unit:unit_data().name_label_id then
		Keepers:DestroyLabel(self._unit)		
	end

	kpr_original_huskcopbrain_clbkdeath(self, my_unit, damage_info)
end