_G.GoodWillSysMain = _G.GoodWillSysMain or {}

if GoodWillSysMain._hooks.add_point_by_using_in_menu then
	return
else
	GoodWillSysMain._hooks.add_point_by_using_in_menu = true
end

local __delay_check_run_out_dt = 0


Hooks:Add("MenuUpdate", _G.GoodWillSysMain.__Name("add_point_by_using_in_menu::1"), function(__t, __dt)
	if __delay_check_run_out_dt > 0 then
		__delay_check_run_out_dt = __delay_check_run_out_dt - __dt
		return
	end
	__delay_check_run_out_dt = 13
	
	local now_unit_list = {}
	
	if managers.menu_scene and managers.menu_scene:get_character_unit() and alive(managers.menu_scene:get_character_unit()) then
		table.insert(now_unit_list, managers.menu_scene:get_character_unit())
	end
	
	local this_lobby_characters = managers.menu_scene._lobby_characters
	if type(this_lobby_characters) == "table" and not table.empty(this_lobby_characters) then
		for _, this_unit in pairs(this_lobby_characters) do
			table.insert(now_unit_list, this_unit)
		end
	end

	local __os_time = os.time()
	
	for _, now_unit in pairs(now_unit_list) do
		local this_char_name = managers.menu_scene:get_character_name(now_unit)
		local __delay = _G.GoodWillSysMain._funcs.__Get_Delay(this_char_name, "add_point_by_using_in_menu")
		if __os_time - __delay >= 60 then
			_G.GoodWillSysMain._funcs.__Set_Delay(this_char_name, "add_point_by_using_in_menu", __os_time+60)
			if __delay > 0 then
				_G.GoodWillSysMain._funcs.__Add_Point(this_char_name, 2)
			end
		end
	end
end)