_G.JokerMask = _G.JokerMask or {}
JokerMask.Mask = JokerMask.Mask or {Nope = "Nope"}

Hooks:PostHook(CopDamage, "convert_to_criminal", "Joker_GetMask", function(self)
	if not alive(self._unit) or not self._unit:inventory() or not self._unit:inventory().JOKERMASK_apply_mask then
		return
	end
	local _mask_unit = nil
	local _mask_data = nil
	if type(JokerMask.Mask) == "table" then
		local try = 10
		local key = table.random_key(JokerMask.Mask)
		while true do
			key = table.random_key(JokerMask.Mask)
			try = try - 1
			if JokerMask.Mask[key] and JokerMask.Mask[key].mask_id then
				break
			end
			if try <= 0 then
				break
			end
		end
		if try <= 0 then
			return
		end
		_mask_data = JokerMask.Mask[key]
		_mask_unit = tweak_data.blackmarket.masks[_mask_data.mask_id].unit
	end
	if not _mask_unit then
		_mask_unit = tweak_data.blackmarket.masks[table.random_key(tweak_data.blackmarket.masks)].unit
	end
	if _mask_unit then
		self:_spawn_head_gadget({
			position = self._unit:movement()._m_head_pos,
			rotation = self._unit:movement()._m_head_rot,
			dir = Vector3(0, 0, 1)
		})
		self._unit:inventory():JOKERMASK_apply_mask(_mask_unit, _mask_data)
	end
end)