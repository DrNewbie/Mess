local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_elementequipment_onexecuted = ElementEquipment.on_executed
function ElementEquipment:on_executed(instigator)
	if alive(instigator) then
		local ub = instigator:base()
		if ub and ub._tweak_table then
			instigator = managers.player:player_unit()
		end
	end

	kpr_original_elementequipment_onexecuted(self, instigator)
end
