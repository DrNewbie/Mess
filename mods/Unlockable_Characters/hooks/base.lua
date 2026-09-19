if _G.UnlockableCharactersSys then
	return
end

_G.UnlockableCharactersSys = {
	_hooks = {},
	_datas = {init = false},
	_funcs = {}
}

_G.UnlockableCharactersSys.ThisModPath = ModPath

_G.UnlockableCharactersSys.ThisModSave = _G.UnlockableCharactersSys.ThisModPath.."/save_files.json"

_G.UnlockableCharactersSys.__Name = function(__id)
	return "UUU_"..Idstring(tostring(__id).."::".._G.UnlockableCharactersSys.ThisModPath):key()
end

_G.UnlockableCharactersSys._funcs.__IsHost = function()
	if Network and Network:is_server() then
		return true
	end
	if Global.game_settings and Global.game_settings.single_player then
		return true
	end
	return false
end

_G.UnlockableCharactersSys._funcs.__IsTutorialHeists = function()
	local __current_level_id = ""
	if Global.game_settings then
		__current_level_id = tostring(Global.game_settings.level_id)
	end
	if __current_level_id == "short1_stage1" or 
		__current_level_id == "short1_stage2" or 
		__current_level_id == "short2_stage1" or 
		__current_level_id == "short2_stage2b" then
		return true
	end
	return false
end

_G.UnlockableCharactersSys._funcs.__Load = function()
	pcall(function()
		local __io = io
		local __save_path = _G.UnlockableCharactersSys.ThisModSave
		local __save_file = __io.open(__save_path, "r")
		if __save_file then
			_G.UnlockableCharactersSys._datas = json.decode(__save_file:read("*all"))
			__save_file:close()
		end
		return
	end)
	return
end

_G.UnlockableCharactersSys._funcs.__Save = function()
	pcall(function()
		local __io = io
		local __save_path = _G.UnlockableCharactersSys.ThisModSave
		local __save_file = __io.open(__save_path, "w+")
		if __save_file then
			__save_file:write(json.encode(_G.UnlockableCharactersSys._datas))
			__save_file:close()
		end
		return
	end)
	return
end

_G.UnlockableCharactersSys._funcs.ShowHint = function(__text, __icon)
	require("lib/managers/hud/HudChallengeNotification")
	local __title = managers.localization:to_upper_text("hud_achieved_popup")
	__icon = __icon or "equipment_chrome_mask"
	HudChallengeNotification.queue(__title, __text, __icon)
	return
end

_G.UnlockableCharactersSys._funcs.IsThisCharacterUnLocked = function(__name)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	if _G.UnlockableCharactersSys._datas[__name] then
		return _G.UnlockableCharactersSys._datas[__name].__unlocked
	end
	return false
end

_G.UnlockableCharactersSys._funcs.SetThisCharacterUnLocked = function(__name, is_bool)
	if type(is_bool) ~= "boolean" then
		return
	end
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.UnlockableCharactersSys._datas[__name] = _G.UnlockableCharactersSys._datas[__name] or {}
	_G.UnlockableCharactersSys._datas[__name].__unlocked = is_bool
	if is_bool and managers.localization and type(_G.UnlockableCharactersSys._funcs.ShowHint) == "function" then
		_G.UnlockableCharactersSys._funcs.ShowHint(
			managers.localization:text("pdstory_reward_"..__name.."_unlocked_name"), 
			_G.UnlockableCharactersSys.__Name("unlock "..__name.."")
		)
	end
	_G.UnlockableCharactersSys._funcs.__Save()
	return
end

_G.UnlockableCharactersSys._funcs.UnLockedThisCharacter = function(__name)
	_G.UnlockableCharactersSys._funcs.SetThisCharacterUnLocked(__name, true)
	return
end

_G.UnlockableCharactersSys._funcs.LockedThisCharacter = function(__name)
	_G.UnlockableCharactersSys._funcs.SetThisCharacterUnLocked(__name, false)
	return
end

_G.UnlockableCharactersSys._funcs.GetThisCharacterLockedDesc = function(__name)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.UnlockableCharactersSys._datas[__name] = _G.UnlockableCharactersSys._datas[__name] or {}
	return _G.UnlockableCharactersSys._datas[__name].__loced_desc or {managers.localization:text("pdstory_reward_"..__name.."_unlocked_desc"), managers.localization:text("pdstory_reward_"..__name.."_unlocked_objective")}
end

_G.UnlockableCharactersSys._funcs.SetThisCharacterLockedDesc = function(__name, __desc)
	__name = CriminalsManager.convert_old_to_new_character_workname(tostring(__name))
	_G.UnlockableCharactersSys._datas[__name] = _G.UnlockableCharactersSys._datas[__name] or {}
	_G.UnlockableCharactersSys._datas[__name].__loced_desc = __desc
	_G.UnlockableCharactersSys._funcs.__Save()
	return
end

_G.UnlockableCharactersSys._funcs.AddThisLevelFinish = function(__lv, __num)
	_G.UnlockableCharactersSys._datas.__level =_G.UnlockableCharactersSys._datas.__level or {}
	_G.UnlockableCharactersSys._datas.__level[__lv] = _G.UnlockableCharactersSys._datas.__level[__lv] or {}
	_G.UnlockableCharactersSys._datas.__level[__lv].__times = _G.UnlockableCharactersSys._datas.__level[__lv].__times or 0
	_G.UnlockableCharactersSys._datas.__level[__lv].__times = _G.UnlockableCharactersSys._datas.__level[__lv].__times + __num
	_G.UnlockableCharactersSys._funcs.__Save()
	return
end

_G.UnlockableCharactersSys._funcs.GetThisLevelFinish = function(__lv)
	_G.UnlockableCharactersSys._datas.__level =_G.UnlockableCharactersSys._datas.__level or {}
	_G.UnlockableCharactersSys._datas.__level[__lv] = _G.UnlockableCharactersSys._datas.__level[__lv] or {}
	_G.UnlockableCharactersSys._datas.__level[__lv].__times = _G.UnlockableCharactersSys._datas.__level[__lv].__times or 0
	return _G.UnlockableCharactersSys._datas.__level[__lv].__times
end

_G.UnlockableCharactersSys._funcs.__CustomAchievement = function()
	pcall(function()
		if CustomAchievementPackage and CriminalsManager then
			local character_names = CriminalsManager.character_names()
			for _, char_name in pairs(character_names) do
				local new_char_name = CriminalsManager.convert_old_to_new_character_workname(char_name)
				local __ach = CustomAchievementPackage:new("pdstory_reward_package")
				local __ach_id = "pdstory_reward_"..new_char_name.."_unlocked"
				if __ach and __ach:HasAchievement(__ach_id) then
					if _G.UnlockableCharactersSys._funcs.IsThisCharacterUnLocked(new_char_name) then
						__ach:Achievement(__ach_id):Unlock()
					else
						__ach:Achievement(__ach_id):Lock()
					end
				end
			end
		end
		return
	end)
	return
end

_G.UnlockableCharactersSys._funcs.__Clear = function()
	_G.UnlockableCharactersSys._datas = {init = false}
	_G.UnlockableCharactersSys._funcs.UnLockedThisCharacter("dallas")
	_G.UnlockableCharactersSys._funcs.__Save()
	return
end

Hooks:PostHook(_G.UnlockableCharactersSys._funcs, "__Load", _G.UnlockableCharactersSys.__Name("Post:__Load"), function()
	_G.UnlockableCharactersSys._funcs.__CustomAchievement()
end)

Hooks:PostHook(_G.UnlockableCharactersSys._funcs, "__Save", _G.UnlockableCharactersSys.__Name("Post:__Save"), function()
	_G.UnlockableCharactersSys._funcs.__CustomAchievement()
end)

_G.UnlockableCharactersSys._funcs.__Load()

_G.UnlockableCharactersSys._funcs.__Save()