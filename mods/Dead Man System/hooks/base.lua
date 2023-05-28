if _G.DeadManSysMain then
	return
end

_G.DeadManSysMain = {
	_hooks = {},
	_datas = {true},
	_funcs = {}
}

_G.DeadManSysMain.ThisModPath = ModPath

_G.DeadManSysMain.ThisModSave = _G.DeadManSysMain.ThisModPath.."/save_files.json"

_G.DeadManSysMain.__Name = function(__id)
	return "DDD_"..Idstring(tostring(__id).."::".._G.DeadManSysMain.ThisModPath):key()
end

_G.DeadManSysMain._funcs.__IsHost = function()
	if Network and Network:is_server() then
		return true
	end
	if Global.game_settings and Global.game_settings.single_player then
		return true
	end
	return false
end

_G.DeadManSysMain._funcs.__Load = function()
	pcall(function()
		local __io = io
		local __save_path = _G.DeadManSysMain.ThisModSave
		local __save_file = __io.open(__save_path, "r")
		if __save_file then
			_G.DeadManSysMain._datas = json.decode(__save_file:read("*all"))
			__save_file:close()
		end
		return
	end)
	return
end

_G.DeadManSysMain._funcs.__Save = function()
	pcall(function()
		local __io = io
		local __save_path = _G.DeadManSysMain.ThisModSave
		local __save_file = __io.open(__save_path, "w+")
		if __save_file then
			__save_file:write(json.encode(_G.DeadManSysMain._datas))
			__save_file:close()
		end
		--[[
		if managers and managers.blackmarket then
			managers.blackmarket:clear_preferred_characters()
		end
		]]
		return
	end)
	return
end

_G.DeadManSysMain._funcs.__Clear = function()
	_G.DeadManSysMain._datas = {true}
	_G.DeadManSysMain._funcs.__Save()
end

_G.DeadManSysMain._funcs.IsThisCharacterDead = function(__name)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	if _G.DeadManSysMain._datas[__name] then
		return _G.DeadManSysMain._datas[__name].__dead
	end
	return false
end

_G.DeadManSysMain._funcs.SetThisCharacterDead = function(__name, is_bool)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.DeadManSysMain._datas[__name] = _G.DeadManSysMain._datas[__name] or {}
	_G.DeadManSysMain._datas[__name].__dead = is_bool
	_G.DeadManSysMain._funcs.__Save()
	return
end

_G.DeadManSysMain._funcs.DefaultCharacterLife = function(__name)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	if __name == "jimmy" then
		return 3
	end
	return 1
end

_G.DeadManSysMain._funcs.SubThisCharacterLife = function(__name, __var)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.DeadManSysMain._datas[__name] = _G.DeadManSysMain._datas[__name] or {}
	_G.DeadManSysMain._datas[__name].__life = _G.DeadManSysMain._datas[__name].__life or _G.DeadManSysMain._funcs.DefaultCharacterLife(__name)
	_G.DeadManSysMain._datas[__name].__life = _G.DeadManSysMain._datas[__name].__life - __var
	if _G.DeadManSysMain._datas[__name].__life <= 0 then
		_G.DeadManSysMain._datas[__name].__dead = true
	end
	_G.DeadManSysMain._funcs.__Save()
	return
end

_G.DeadManSysMain._funcs.SetThisCharacterDeadDesc = function(__name, __desc)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.DeadManSysMain._datas[__name] = _G.DeadManSysMain._datas[__name] or {}
	_G.DeadManSysMain._datas[__name].__dead_desc = __desc
	_G.DeadManSysMain._funcs.__Save()
	return
end

_G.DeadManSysMain._funcs.GetThisCharacterDeadDesc = function(__name)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.DeadManSysMain._datas[__name] = _G.DeadManSysMain._datas[__name] or {}
	return _G.DeadManSysMain._datas[__name].__dead_desc or {"R.I.P"}
end

_G.DeadManSysMain._funcs.__Load()

_G.DeadManSysMain._funcs.__Save()