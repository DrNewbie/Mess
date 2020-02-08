local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_coplogictrade_enter = CopLogicTrade.enter
function CopLogicTrade.enter(data, new_logic_name, enter_params)
	if data.unit:unit_data().name_label_id then
		Keepers:DestroyLabel(data.unit)		
	end

	kpr_original_coplogictrade_enter(data, new_logic_name, enter_params)
end
