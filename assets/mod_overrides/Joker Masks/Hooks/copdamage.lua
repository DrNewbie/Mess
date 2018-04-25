Hooks:PostHook(CopDamage, "convert_to_criminal", "Joker_GetMask", function(self)
	if not alive(self._unit) or not self._unit:inventory() or not self._unit:inventory().JOKERMASK_apply_mask then
		return
	end
	local _mask_unit = tweak_data.blackmarket.masks[table.random_key(tweak_data.blackmarket.masks)].unit
	if _mask_unit then
		self:_spawn_head_gadget({
			position = self._unit:movement()._m_head_pos,
			rotation = self._unit:movement()._m_head_rot,
			dir = Vector3(0, 0, 1)
		})
		self._unit:inventory():JOKERMASK_apply_mask(_mask_unit)
	end
end)