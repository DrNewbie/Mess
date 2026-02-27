_G.GoodWillSysMain = _G.GoodWillSysMain or {}

if GoodWillSysMain._hooks.add_point_by_playing then
	return
else
	GoodWillSysMain._hooks.add_point_by_playing = true
end

local __delay_check_run_out_dt = 0


Hooks:Add("GameSetupUpdate", _G.GoodWillSysMain.__Name("add_point_by_playing::1"), function(__t, __dt)
	if __delay_check_run_out_dt > 0 then
		__delay_check_run_out_dt = __delay_check_run_out_dt - __dt
		return
	end
	__delay_check_run_out_dt = 7
	

	if not managers.criminals then
		return
	end
	
	local current_criminals = managers.groupai:state():all_char_criminals()

	local __os_time = os.time()

	if managers.criminals and type(current_criminals) == "table" and not table.empty(current_criminals) then
		for _, __data in pairs(current_criminals) do
			if __data.unit and alive(__data.unit) then
				local this_char_name = tostring(managers.criminals:character_name_by_unit(__data.unit))
				local __delay = _G.GoodWillSysMain._funcs.__Get_Delay(this_char_name, "add_point_by_playing")
				if __os_time - __delay >= 60 then
					_G.GoodWillSysMain._funcs.__Set_Delay(this_char_name, "add_point_by_playing", __os_time+60)
					if __delay > 0 then
						_G.GoodWillSysMain._funcs.__Add_Point(this_char_name, 10)
						if managers.player and managers.player:local_player() and alive(managers.player:local_player()) and __data.unit == managers.player:local_player() then
							_G.GoodWillSysMain._funcs.__Add_Point(this_char_name, 10)
						end
					end
				end
			end
		end
	end
end)