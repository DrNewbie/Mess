NumberPadToKeyPadHack = NumberPadToKeyPadHack or {}

function NumberPadToKeyPadHack:Main(__in)
	__in = tostring(__in)
	local __allow_keys_type1 = {
		__ids = Idstring("units/pd2_dlc_casino/props/cas_prop_keypad/cas_prop_button"):key(),
		cas_button_01 = true,
		cas_button_02 = true,
		cas_button_03 = true,
		cas_button_04 = true,
		cas_button_05 = true,
		cas_button_06 = true,
		cas_button_07 = true,
		cas_button_08 = true,
		cas_button_09 = true,
		cas_button_0 = true,
		cas_button_clear = true,
		cas_button_enter = true
	}
	local __allow_keys_type2 = {
		__ids = Idstring("units/pd2_dlc_sand/props/sand_prop_intercom/sand_interactable_intercom_button"):key(),
		cas_button_01 = true,
		cas_button_02 = true,
		cas_button_03 = true,
		cas_button_04 = true,
		cas_button_05 = true,
		cas_button_06 = true,
		cas_button_07 = true,
		cas_button_08 = true,
		cas_button_09 = true,
		cas_button_0 = true,
		cas_button_clear = true,
		cas_button_enter = true,
		sand_button_number_sign = true
	}
	local __allow_keys_type3 = {
		__ids = Idstring("units/pd2_dlc_sand/props/sand_prop_keypad/sand_interactable_button"):key(),
		cas_button_01 = true,
		cas_button_02 = true,
		cas_button_03 = true,
		cas_button_04 = true,
		cas_button_05 = true,
		cas_button_06 = true,
		cas_button_07 = true,
		cas_button_08 = true,
		cas_button_09 = true,
		cas_button_0 = true,
		cas_button_clear = true,
		cas_button_enter = true
	}
	local __allows_pads = {
		[Idstring("units/pd2_dlc_tag/props/tag_prop_keypad/tag_prop_keypad"):key()] = __allow_keys_type1,
		[Idstring("units/pd2_dlc_casino/props/cas_prop_keypad/cas_prop_keypad"):key()] = __allow_keys_type1,
		[Idstring("units/pd2_dlc_sand/props/sand_prop_intercom/sand_prop_intercom"):key()] = __allow_keys_type2,
		[Idstring("units/pd2_dlc_sand/props/sand_prop_keypad/sand_prop_keypad"):key()] = __allow_keys_type3
	}
	local __ply = managers.player:player_unit()
	if not __ply or not __ply:movement() then
		return
	end
	local camera = __ply:movement()._current_state._ext_camera
	local mvec_to = Vector3()
	local from_pos = camera:position()
	mvector3.set(mvec_to, camera:forward())
	mvector3.multiply(mvec_to, 20000)
	mvector3.add(mvec_to, from_pos)
	local __rays = World:raycast("ray", from_pos, mvec_to, "slot_mask", 1)
	if type(__rays) == "table" and __rays.unit and __allows_pads[__rays.unit:name():key()] then
		local __pad_data = __allows_pads[__rays.unit:name():key()]
		local __units = World:find_units("sphere", __rays.unit:position(), 100, 1)
		if __pad_data[__in] then
			for _, __unit in pairs(__units) do 
				if __unit and alive(__unit) and type(__unit.interaction) == "function" and __unit:name():key() == __pad_data.__ids and __unit:interaction() and tostring(__unit:interaction().tweak_data) == __in then
					local __key_button = __unit:interaction()
					if __key_button:can_select(__ply) and __key_button:can_interact(__ply) and __key_button:active() and not __key_button:disabled() then
						__unit:interaction():interact(__ply)
						break
					end
				end
			end
		end
	end
end