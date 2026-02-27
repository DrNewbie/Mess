_G.GoodWillSysMain = _G.GoodWillSysMain or {}

if GoodWillSysMain._hooks.decrease_by_time_pass then
	return
else
	GoodWillSysMain._hooks.decrease_by_time_pass = true
end

local __delay_check_run_out_dt = 0

local function __decrease_by_time_pass(__t, __dt)
	if __delay_check_run_out_dt > 0 then
		__delay_check_run_out_dt = __delay_check_run_out_dt - __dt
		return
	end
	__delay_check_run_out_dt = 19
	
	local __os_time = os.time()
	
	local __char = _G.GoodWillSysMain._datas.__char
	for this_char_name, this_char_point in pairs(__char) do
		local __delay = _G.GoodWillSysMain._funcs.__Get_Delay(this_char_name, "decrease_by_time_pass")
		if __os_time - __delay >= 1800 then
			_G.GoodWillSysMain._funcs.__Set_Delay(this_char_name, "decrease_by_time_pass", __os_time+1800)
			if __delay > 0 then
				_G.GoodWillSysMain._funcs.__Add_Point(this_char_name, -math.round((__os_time - __delay)/1800))
			end
		end
	end
	
	return
end

Hooks:Add("MenuUpdate", _G.GoodWillSysMain.__Name("__decrease_by_time_pass::1"), function(__t, __dt)
	__decrease_by_time_pass(__t, __dt)
end)

Hooks:Add("GameSetupUpdate", _G.GoodWillSysMain.__Name("__decrease_by_time_pass::2"), function(__t, __dt)
	__decrease_by_time_pass(__t, __dt)
end)