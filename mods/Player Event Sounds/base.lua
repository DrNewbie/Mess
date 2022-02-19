--Must have
if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local IS_DEBUG_LOL = false

--Add New Event
Message.on_temporary_upgrades_start = #Message + 1
Message.on_temporary_upgrades_end = #Message + 1

--Path Init
_G.MessageSoundsEventt = _G.MessageSoundsEventt or {}
_G.MessageSoundsEventt.ThisModPath = _G.MessageSoundsEventt.ThisModPath or ModPath
_G.MessageSoundsEventt.MessageSoundPath = _G.MessageSoundsEventt.ThisModPath .. "sounds/"

--Function to give unique name
_G.MessageSoundsEventt.NameIds = function(__name)
	return "MSEtt_"..Idstring(tostring(__name).."::".._G.MessageSoundsEventt.ThisModPath):key()
end

--Shorten
local function __NameIds(__name)
	return _G.MessageSoundsEventt.NameIds(__name)
end

--Unique name for register
_G.MessageSoundsEventt.MsgName = __NameIds("MsgName")

--Add function from cfgs
_G.MessageSoundsEventt.AddMsgFunc = function(__msg, __name, __func)
	if type(__msg) == "string" and type(__func) == "function" then
		__name = __name or tostring(__func)
		_G.MessageSoundsEventt[__msg] = _G.MessageSoundsEventt[__msg] or {}
		_G.MessageSoundsEventt[__msg].MsgFuncs = _G.MessageSoundsEventt[__msg].MsgFuncs or {}
		_G.MessageSoundsEventt[__msg].MsgFuncs[__NameIds(__name)] = __func
		--Re-define register_message
		if managers.player then
			local __MSEtt = _G.MessageSoundsEventt
			managers.player:unregister_message(Message[__msg], __MSEtt.MsgName)
			managers.player:register_message(Message[__msg], __MSEtt.MsgName, function(...)
				if type(__MSEtt[__msg]) == "table" and type(__MSEtt[__msg].MsgFuncs) == "table" then
					for _, __sub_func in pairs(__MSEtt[__msg].MsgFuncs) do
						if type(__sub_func) == "function" then
							__sub_func(...)
						end
					end
				end
			end)
		end
		return __NameIds(__name)
	end
	return
end

--Scan dir codes from n0tEll10T, https://modworkshop.net/mod/35405
local __scan_dir = function(__this_dir)
	local __i, __t, __popen = 0, {}, io.popen
	local __pfile = __popen('dir "'..__this_dir..'" /B /S /A-D')
	for __filename in __pfile:lines() do
		if string.match(__filename, "%.ogg") then
			__i = __i + 1
			__t[__NameIds(__filename)] = __filename
		end
	end
	__pfile:close()
	return __t
end

--Init, get cfg and sound name
_G.MessageSoundsEventt.Init = function()
	local __MSEtt = _G.MessageSoundsEventt
	if file.DirectoryExists(__MSEtt.ThisModPath.."cfgs/") then
		local __configs = file.GetFiles(__MSEtt.ThisModPath.."cfgs/")
		if type(__configs) == "table" then
			for _, __cfg in pairs(__configs) do
				if __cfg and io.file_is_readable(__MSEtt.ThisModPath.."cfgs/"..__cfg) then
					if string.match(__MSEtt.ThisModPath.."cfgs/"..__cfg, "%.lua") then
						dofile(__MSEtt.ThisModPath.."cfgs/"..__cfg)
					end
				end
			end
		end
	end
	for __msg, _ in pairs(Message) do
		if file.DirectoryExists(__MSEtt.MessageSoundPath) then
			local __msg_path = __MSEtt.MessageSoundPath..__msg.."/"
			if file.DirectoryExists(__msg_path) then				
				_G.MessageSoundsEventt[__msg] = _G.MessageSoundsEventt[__msg] or {}
				_G.MessageSoundsEventt[__msg].MsgOGGs = __scan_dir(__msg_path)
			else
				if IS_DEBUG_LOL then
					os.execute('MKDIR "'.. Application:nice_path(Application:base_path()..__msg_path, true) ..'"')
				end
			end
			if IS_DEBUG_LOL and not io.file_is_readable(__msg_path.."/empty.folder") then
				local __file = io.open( __msg_path.."/empty.folder", "w+")
				__file:close()
			end
		end
	end
	dofile(__MSEtt.ThisModPath.."skill_base.lua")
	return
end

_G.MessageSoundsEventt.Default = function()
	if not managers.player then
		return
	end
	local __MSEtt = _G.MessageSoundsEventt
	for __msg, _ in pairs(Message) do
		local __is_ok
		if type(__MSEtt[__msg]) == "table" and type(__MSEtt[__msg].MsgFuncs) == "table" then
			local __MsgFuncs = __MSEtt[__msg].MsgFuncs
			for __key, __func in pairs(__MsgFuncs) do
				if type(__func) == "function" then
					__is_ok = true
					break
				end
			end
		end
		if not __is_ok then
			if Message[__msg] == Message.on_temporary_upgrades_start or Message[__msg] == Message.on_temporary_upgrades_end then
				-- temporary upgrades start&end use different default function
				_G.MessageSoundsEventt.AddMsgFunc(__msg, "Default_Event", function(__category, __upgrade)					
					_G.MessageSoundsEventt.MessageSoundPath
					_G.MessageSoundsEventt[__msg] = _G.MessageSoundsEventt[__msg] or {}
					local __OggsFolder = _G.MessageSoundsEventt.MessageSoundPath .. __msg .. "/" .. __category .. "/" .. __upgrade
					local __OggsFolder_Ids = _G.MessageSoundsEventt.NameIds(__OggsFolder)
					_G.MessageSoundsEventt[__msg][__OggsFolder_Ids] = _G.MessageSoundsEventt[__msg][__OggsFolder_Ids] or {}
					if table.empty(_G.MessageSoundsEventt[__msg][__OggsFolder_Ids]) then
						_G.MessageSoundsEventt[__msg][__OggsFolder_Ids] = __scan_dir(__OggsFolder)
					end
					local __MsgOGGs = _G.MessageSoundsEventt[__msg][__OggsFolder_Ids]
					_G.MessageSoundsEventt.PlaySoundOne(tostring(__MsgOGGs[table.random_key(__MsgOGGs)]))
					return
				end)
			else
				--Add default sound event to support all
				_G.MessageSoundsEventt.AddMsgFunc(__msg, "Default_Event", function()
					if managers.player then
						_G.MessageSoundsEventt.PlaySoundRandom(__msg)
					end
					return
				end)
			end
		end
	end
end

--Play sound
_G.MessageSoundsEventt.PlaySoundOne = function(__name)
	local __MSEtt = _G.MessageSoundsEventt
	local ThisOGGPath = tostring(__name)
	if io.file_is_readable(ThisOGGPath) then
		if managers.player and managers.player:player_unit() then
			XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(ThisOGGPath)):set_volume(1)
			return true
		else
			XAudio.Source:new(XAudio.Buffer:new(ThisOGGPath)):set_volume(1)
			return true
		end
	end
	return false
end

--Play random sound by message name
_G.MessageSoundsEventt.PlaySoundRandom = function(__msg)
	_G.MessageSoundsEventt[__msg] = _G.MessageSoundsEventt[__msg] or {}
	_G.MessageSoundsEventt[__msg].MsgOGGs = _G.MessageSoundsEventt[__msg].MsgOGGs or {}
	local __MSEtt = _G.MessageSoundsEventt
	local __MsgOGGs = __MSEtt[__msg].MsgOGGs
	if type(__MsgOGGs) == "table" then
		return __MSEtt.PlaySoundOne(tostring(__MsgOGGs[table.random_key(__MsgOGGs)]))
	end
	return false
end

--Do Init
Hooks:PostHook(Setup, "init_managers", __NameIds("Do Setup"), function(self)
	_G.MessageSoundsEventt.Init()
	_G.MessageSoundsEventt.Default()
end)