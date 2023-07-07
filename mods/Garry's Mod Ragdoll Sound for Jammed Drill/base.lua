local ThisModPath = ModPath
local ThisOGG = ThisModPath.."912385876.ogg"

if blt.xaudio and io.file_is_readable(ThisOGG) then
	blt.xaudio.setup()
else
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
		local this_source = XAudio.UnitSource:new(__drill_unit)
		this_source:set_buffer(this_buffer)
		this_source:play()
		this_source:set_volume(1)
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
local IsFine = __Name(3)

Hooks:PostHook(TimerGui, "init", __Name(4), function(self, ...)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" and not self[IsBool] then
		local __u_key = __Name(self._unit:key())
		_G[_GName][__u_key] = _G[_GName][__u_key] or {}
		self[IsBool] = true
		self[IsMove] = false
		self[IsFine] = false
	end
end)

Hooks:PostHook(TimerGui, "update", __Name(5), function(self, ...)
	if self._unit and alive(self._unit) and self[IsBool] then
		if self[IsFine] then
			self[IsFine] = false
		else
			self[IsFine] = true
			local player_unit = managers.player:player_unit()
			local __u_key = __Name(self._unit:key())
			if self._jammed and player_unit then
				if not self[IsMove] then
					self[IsMove] = true
					pcall(__end_ogg, __u_key)
					pcall(__ply_ogg, self._unit)
				else
					local this_source = _G[_GName][__u_key][XAudioSource] or nil
					local is_active = this_source and this_source:is_active() or nil
					if not is_active then
						pcall(__end_ogg, __u_key)
						self[IsMove] = false
					else
						pcall(function ()
							local this_dis = mvector3.distance(player_unit:position(), self._unit:position())
							if this_dis >= 800 then
								this_source:set_volume(0)
							else
								this_source:set_volume((800-this_dis)/800)
							end
						end)
					end
				end
			else
				if this_source or this_buffer then
					pcall(__end_ogg, __u_key)
				end
				pcall(function ()
					self[IsMove] = false
				end)
			end
		end
	end
end)