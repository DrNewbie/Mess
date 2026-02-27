_G.GoodWillSysMain._datas.__char = _G.GoodWillSysMain._datas.__char or {}

if GoodWillSysMain._hooks.add_point_by_talking_in_safehouse then
	return
else
	GoodWillSysMain._hooks.add_point_by_talking_in_safehouse = true
end

Hooks:PostHook(CivilianHeisterInteractionExt, "interact", GoodWillSysMain.__Name("add_point_by_talking_in_safehouse"), function(self)
	if not managers.player or not self.character then
		return
	end
	
	local __char_name = self.character
	local __os_time = os.time()
	local __delay = GoodWillSysMain._funcs.__Get_Delay(__char_name, "add_point_by_talking_in_safehouse")
	if math.abs((__os_time-__delay)/86400) < 1.000 then
		return
	end
	GoodWillSysMain._funcs.__Set_Delay(__char_name, "add_point_by_talking_in_safehouse", __os_time + 86400)
	
	GoodWillSysMain._funcs.__Add_Point(__char_name, 100)
end)