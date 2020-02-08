local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_teamaimovement_setcarryingbag = TeamAIMovement.set_carrying_bag
function TeamAIMovement:set_carrying_bag(unit)
	fs_original_teamaimovement_setcarryingbag(self, unit)
	if unit and not unit:carry_data():can_explode() then
		unit:set_extension_update_enabled(Idstring('carry_data'), false)
	end
end
