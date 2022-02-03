local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local ThisModMain = "M_"..Idstring("ThisModMain::"..ThisModIds):key()
_G[ThisModMain] = _G[ThisModMain] or {}
_G.MetalSlugGameModeMIds = ThisModMain

if _G[ThisModMain].Is_True then return end

_G[ThisModMain].NameIds = function(__text)
	return "K_"..Idstring(tostring(__text).."::"..ThisModIds):key()
end

local function __NameIds(__text)
	return _G[ThisModMain].NameIds(__text)
end

_G[ThisModMain].PlaySound = function(__ogg)
	if type(_G[ThisModMain].Sounds[__NameIds(__ogg)]) == "function" then
		_G[ThisModMain].Sounds[__NameIds(__ogg)]()
	end
	return
end

local function __PlaySound(__ogg)
	return _G[ThisModMain].PlaySound(__ogg)
end

_G[ThisModMain].Init = function()
	_G[ThisModMain].Is_True = true
	if blt.xaudio then
		blt.xaudio.setup()
		_G[ThisModMain].Is_Xaudio = true
		_G[ThisModMain].Sounds = {}
		local ogg_files = file.GetFiles(ThisModPath.."sounds/")
		if type(ogg_files) == "table" then
			for _, __ogg in pairs(ogg_files) do
				if io.file_is_readable(ThisModPath.."sounds/"..__ogg) then
					_G[ThisModMain].Sounds[__NameIds(__ogg)] = function()
						XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(ThisModPath.."sounds/"..__ogg)):set_volume(1)
						return
					end
				end
			end
		end
	end
	local lua_files = file.GetFiles(ThisModPath.."lua/")
	if type(lua_files) == "table" then
		for _, __lua in pairs(lua_files) do
			if io.file_is_readable(ThisModPath.."lua/"..__lua) then
				dofile(tostring(ThisModPath.."lua/"..__lua))
			end
		end
	end
	if managers.job and current_job_id() == "run" then
		_G[ThisModMain].Is_Running = true
	elseif Global.game_settings and Global.game_settings.level_id == "run" then
		_G[ThisModMain].Is_Running = true
	end
	_G[ThisModMain].Is_Running = true
	return
end

_G[ThisModMain].InsetUnitsToCheck = function(__unit, __data)
	local key_id = __NameIds(__unit)
	_G[ThisModMain].UnitsToCheck = _G[ThisModMain].UnitsToCheck or {}
	__data.unit = __unit
	__data.t = __data.t or 1
	__data.event = __data.event or 1
	_G[ThisModMain].UnitsToCheck[key_id] = __data
	return key_id
end

_G[ThisModMain].SpawnText = function(__text, __pos, __rot)
	local __unit_name_ids = Idstring("units/dev_tools/editable_text_long/editable_text_long")
	local __text_unit = safe_spawn_unit(__unit_name_ids, __pos, __rot)
	if __text_unit.editable_gui and __text_unit:editable_gui() then
		__text_unit:editable_gui():set_text(tostring(__text))
	end
	return __text_unit
end

_G[ThisModMain].SpawnGun = function(__unit_name_ids, __pos, __rot)
	local __wep_unit = safe_spawn_unit(__unit_name_ids, __pos, __rot)
	if __wep_unit then
		local setup_data = {}
		setup_data.user_unit = managers.player:player_unit()
		setup_data.ignore_units = {
			managers.player:player_unit(),
			__wep_unit
		}
		__wep_unit:base():setup(setup_data)
	end
	return __wep_unit
end

_G[ThisModMain].Get_PlyStandard = function()
	return managers.player and managers.player:player_unit() and managers.player:player_unit():movement() and managers.player:player_unit():movement()._states.standard or nil
end

_G[ThisModMain].Init()