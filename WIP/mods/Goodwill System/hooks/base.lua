if _G.GoodWillSysMain then
	return
end

_G.GoodWillSysMain = _G.GoodWillSysMain or {
	_hooks = {true},
	_datas = {true},
	_funcs = {true}
}

_G.GoodWillSysMain.ThisModPath = ModPath

_G.GoodWillSysMain.ThisModSave = _G.GoodWillSysMain.ThisModPath.."save_files.json"

_G.GoodWillSysMain.__Name = function(__id)
	return "DDD_"..Idstring(tostring(__id).."::".._G.GoodWillSysMain.ThisModPath):key()
end

_G.GoodWillSysMain._funcs.__IsHost = function()
	if Network and Network:is_server() then
		return true
	end
	if Global.game_settings and Global.game_settings.single_player then
		return true
	end
	return false
end

_G.GoodWillSysMain._funcs.__Load = function()
	pcall(function()
		if io.file_is_readable(_G.GoodWillSysMain.ThisModSave) then
			_G.GoodWillSysMain._datas = io.load_as_json(_G.GoodWillSysMain.ThisModSave)
			_G.GoodWillSysMain._funcs.__Save()
		end
		if type(_G.GoodWillSysMain._datas) ~= "table" then
			_G.GoodWillSysMain._funcs.__Clear()
		end
		return
	end)
	return
end

_G.GoodWillSysMain._funcs.__Save = function()
	DelayedCalls:Add(_G.GoodWillSysMain.__Name("__Save"), 1, function()
		pcall(function()
			if type(_G.GoodWillSysMain._datas) ~= "table" then
				_G.GoodWillSysMain._funcs.__Clear()
			end
			io.save_as_json(_G.GoodWillSysMain._datas, _G.GoodWillSysMain.ThisModSave)
			return
		end)
	end)
	return
end

_G.GoodWillSysMain._funcs.__Set_Point = function(__char_name, __var)
	if type(__char_name) ~= "string" or type(__var) ~= "number" then
		return
	end
	__char_name = CriminalsManager.convert_old_to_new_character_workname(__char_name)
	_G.GoodWillSysMain._datas.__char = _G.GoodWillSysMain._datas.__char or {}
	_G.GoodWillSysMain._datas.__char[__char_name] = math.clamp(__var, 0, 10000)
	_G.GoodWillSysMain._funcs.__Save()
	return
end

_G.GoodWillSysMain._funcs.__Get_Point = function(__char_name)
	if type(__char_name) ~= "string" then
		return
	end
	__char_name = CriminalsManager.convert_old_to_new_character_workname(__char_name)
	_G.GoodWillSysMain._datas.__char = _G.GoodWillSysMain._datas.__char or {}
	_G.GoodWillSysMain._datas.__char[__char_name] = _G.GoodWillSysMain._datas.__char[__char_name] or 0
	return math.clamp(_G.GoodWillSysMain._datas.__char[__char_name], 0, 10000)
end

_G.GoodWillSysMain._funcs.__Add_Point = function(__char_name, __var)
	if type(__char_name) ~= "string" or type(__var) ~= "number" then
		return
	end
	__char_name = CriminalsManager.convert_old_to_new_character_workname(__char_name)
	_G.GoodWillSysMain._datas.__char = _G.GoodWillSysMain._datas.__char or {}
	_G.GoodWillSysMain._datas.__char[__char_name] = _G.GoodWillSysMain._datas.__char[__char_name] or 0
	_G.GoodWillSysMain._datas.__char[__char_name] = math.clamp(_G.GoodWillSysMain._datas.__char[__char_name] + __var, 0, 10000)
	_G.GoodWillSysMain._funcs.__Save()
	return
end

_G.GoodWillSysMain._funcs.__Set_Delay = function(__char_name, __delay_name, __var)
	if type(__char_name) ~= "string" or type(__delay_name) ~= "string" or type(__var) ~= "number" then
		return
	end
	__delay_name = _G.GoodWillSysMain.__Name(__delay_name)
	__char_name = CriminalsManager.convert_old_to_new_character_workname(__char_name)
	_G.GoodWillSysMain._datas.__char_delay = _G.GoodWillSysMain._datas.__char_delay or {}
	_G.GoodWillSysMain._datas.__char_delay[__char_name] = _G.GoodWillSysMain._datas.__char_delay[__char_name] or {}
	_G.GoodWillSysMain._datas.__char_delay[__char_name][__delay_name] = __var
	_G.GoodWillSysMain._funcs.__Save()
	return
end

_G.GoodWillSysMain._funcs.__Get_Delay = function(__char_name, __delay_name)
	if type(__char_name) ~= "string" or type(__delay_name) ~= "string" then
		return 0
	end
	__delay_name = _G.GoodWillSysMain.__Name(__delay_name)
	__char_name = CriminalsManager.convert_old_to_new_character_workname(__char_name)
	_G.GoodWillSysMain._datas.__char_delay = _G.GoodWillSysMain._datas.__char_delay or {}
	_G.GoodWillSysMain._datas.__char_delay[__char_name] = _G.GoodWillSysMain._datas.__char_delay[__char_name] or {}
	return _G.GoodWillSysMain._datas.__char_delay[__char_name][__delay_name] or 0
end

_G.GoodWillSysMain._funcs.__Clear = function()
	_G.GoodWillSysMain._datas = {true}
	_G.GoodWillSysMain._funcs.__Save()
	return
end

_G.GoodWillSysMain._funcs.__Load()

_G.GoodWillSysMain._funcs.__Save()