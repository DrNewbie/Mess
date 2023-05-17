local ThisModPath = ModPath

--[[File Path]]
local ThisOGG = ThisModPath.."912385876.ogg"

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

if not io.file_is_readable(ThisOGG) then
	return
end

local __Name = function(__id)
	return "JJJ_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local XAudioBuffer = __Name("XAudioBuffer")
local XAudioSource = __Name("XAudioSource")

local _GName = __Name("_G")
_G[_GName] = _G[_GName] or {}

local function __ply_ogg(__drill_unit)
	local __key = __Name(__drill_unit:key())
	if io.file_is_readable(ThisOGG) then
		local this_buffer = XAudio.Buffer:new(ThisOGG)
		local this_source = XAudio.UnitSource:new(__drill_unit, this_buffer)
		_G[_GName][__key] = _G[_GName][__key] or {}
		_G[_GName][__key][XAudioBuffer] = this_buffer
		_G[_GName][__key][XAudioSource] = this_source
	end
	return
end

local function __end_ogg(__key)
	if type(_G[_GName][__key]) == "table" then
		if type(_G[_GName][__key][XAudioSource]) == "table" then
			_G[_GName][__key][XAudioSource]:close(true)
			_G[_GName][__key][XAudioSource] = nil
		end
		if type(_G[_GName][__key][XAudioBuffer]) == "table" then
			_G[_GName][__key][XAudioBuffer]:close(true)
			_G[_GName][__key][XAudioBuffer] = nil
		end
	end
	return
end

local IsBool = __Name(1)
local IsMove = __Name(2)

Hooks:PostHook(TimerGui, "init", __Name(3), function(self, ...)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" and not self[IsBool] then
		local __u_key = __Name(self._unit:key())
		_G[_GName][__u_key] = _G[_GName][__u_key] or {}
		self[IsBool] = true
		self[IsMove] = false
	end
end)

Hooks:PostHook(TimerGui, "update", __Name(4), function(self, ...)
	if self._unit and alive(self._unit) and self[IsBool] then
		local __u_key = __Name(self._unit:key())
		if self._jammed then
			if not self[IsMove] then
				self[IsMove] = true
				pcall(__end_ogg, __u_key)
				pcall(__ply_ogg, self._unit)
			else
				local is_active = _G[_GName][__u_key][XAudioSource]:is_active()
				if not is_active then
					self[IsMove] = false
					pcall(__end_ogg, __u_key)
				end
			end
		else
			self[IsMove] = false
			pcall(__end_ogg, __u_key)
		end
	end
end)