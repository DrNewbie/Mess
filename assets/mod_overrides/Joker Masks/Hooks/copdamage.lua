_G.JokerMask = _G.JokerMask or {}
JokerMask.Mask = JokerMask.Mask or {Nope = "Nope"}

function JokerMask:Get_Mask(joker_unit)
	if not alive(joker_unit) or not joker_unit:inventory() then
		return
	end
	if not joker_unit:inventory().JOKERMASK_apply_mask then
		return
	end
	local _mask_unit = nil
	local _mask_data = nil
	if type(self.Mask) == "table" then
		local try = 10
		local key = table.random_key(self.Mask)
		while true do
			key = table.random_key(self.Mask)
			try = try - 1
			if self.Mask[key] and self.Mask[key].mask_id then
				break
			end
			if try <= 0 then
				break
			end
		end
		if try <= 0 then
		else
			log("key: "..key)
			_mask_data = self.Mask[key]
			_mask_unit = tweak_data.blackmarket.masks[_mask_data.mask_id].unit		
		end
	end
	if not _mask_unit then
		_mask_unit = tweak_data.blackmarket.masks[table.random_key(tweak_data.blackmarket.masks)].unit
	end
	if _mask_unit then
		if joker_unit:character_damage() and joker_unit:character_damage()._spawn_head_gadget then
			joker_unit:character_damage():_spawn_head_gadget({
				position = joker_unit:movement()._m_head_pos,
				rotation = joker_unit:movement()._m_head_rot,
				dir = Vector3(0, 0, 1)
			})
		end
		joker_unit:inventory():JOKERMASK_apply_mask(_mask_unit, _mask_data)
	end
end

Hooks:PostHook(CopDamage, "convert_to_criminal", "JokerMask_CopDamage", function(self)
	JokerMask:Get_Mask(self._unit)
end)