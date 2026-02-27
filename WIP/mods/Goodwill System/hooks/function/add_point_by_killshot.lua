_G.GoodWillSysMain._datas.__char = _G.GoodWillSysMain._datas.__char or {}

if GoodWillSysMain._hooks.add_point_by_killshot then
	return
else
	GoodWillSysMain._hooks.add_point_by_killshot = true
end

local this_number = 0

local Diff_Delay = {
	normal = 19,
	hard = 17,
	overkill = 13,
	overkill_145 = 11,
	easy_wish = 7,
	overkill_290 = 5,
	sm_wish = 3
}

Hooks:PreHook(PlayerManager, "on_killshot", GoodWillSysMain.__Name("add_point_by_killshot::1"), function(self)
	this_number = self._num_kills
end)

Hooks:PostHook(PlayerManager, "on_killshot", GoodWillSysMain.__Name("add_point_by_killshot::2"), function(self)
	if not managers.criminals or not self:local_player() or not alive(self:local_player()) then
		return
	end
	if type(self._num_kills) ~= type(this_number) then
		return
	end
	if self._num_kills == this_number or self._num_kills < this_number then
		return
	end
	this_number = self._num_kills

	local this_char_name = tostring(managers.criminals:character_name_by_unit(self:local_player()))
	local __delay = _G.GoodWillSysMain._funcs.__Get_Delay(this_char_name, "add_point_by_killshot")
	
	local __os_time = os.time()
	
	if __os_time >= __delay then
		local __difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
		local this_diff_delay = Diff_Delay[__difficulty] or 19
		_G.GoodWillSysMain._funcs.__Set_Delay(this_char_name, "add_point_by_killshot", __os_time + this_diff_delay)
		_G.GoodWillSysMain._funcs.__Add_Point(this_char_name, 1)
	end
end)