local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function CopActionHurt:is_network_allowed(action_desc)
	if not CopActionHurt.network_allowed_hurt_types[action_desc.hurt_type] then
		return false
	end

	if action_desc.allow_network == false then
		return false
	end

	if self._unit:in_slot(managers.slot:get_mask('criminals')) then
		if not managers.groupai:state():is_enemy_converted_to_criminal(self._unit) then
			return false
		end
	end

	return true
end
