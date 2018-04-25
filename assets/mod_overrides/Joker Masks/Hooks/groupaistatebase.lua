Hooks:PostHook(GroupAIStateBase, "convert_hostage_to_criminal", "Joker_GetMask", function(self, unit)
	if not alive(unit) or not unit:inventory() or not unit:character_damage() or not unit:inventory().JOKERMASK_apply_mask then
		return
	end
	local _mask_unit = tweak_data.blackmarket.masks[table.random_key(tweak_data.blackmarket.masks)].unit
	if _mask_unit then
		unit:character_damage():_spawn_head_gadget({
			position = unit:movement()._m_head_pos,
			rotation = unit:movement()._m_head_rot,
			dir = Vector3(0, 0, 1)
		})
		unit:inventory():JOKERMASK_apply_mask(_mask_unit)
	end
end)