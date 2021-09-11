NumberPadToKeyPadHack = NumberPadToKeyPadHack or {}

function NumberPadToKeyPadHack:Main(__in)
	__in = tostring(__in)
	local __allow_keys = {
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
	if not __allow_keys[__in] then
		return
	end
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
	if type(__rays) == "table" and __rays.unit and __rays.unit:name():key() == Idstring("units/pd2_dlc_casino/props/cas_prop_keypad/cas_prop_keypad"):key() then
		local __units = World:find_units("sphere", __rays.unit:position(), 100, managers.slot:get_mask("all"))
		for _, __unit in pairs(__units) do 
			if __unit and alive(__unit) and type(__unit.interaction) == "function" and __unit:name():key() == Idstring("units/pd2_dlc_casino/props/cas_prop_keypad/cas_prop_button"):key() then
				if __unit:interaction() and tostring(__unit:interaction().tweak_data) == __in then
					local __key_button = __unit:interaction()
					if __key_button:can_select(__ply) and __key_button:can_interact(__ply) and __key_button:active() and not __key_button:disabled() then
						__unit:interaction():interact(__ply)
					end
				end
			end
		end
	end
end