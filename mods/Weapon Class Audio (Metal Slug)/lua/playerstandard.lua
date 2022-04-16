local ThisModPath = ModPath

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local ThisModOggs = ThisModPath.."oggs/"
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "WCAMS_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local _GName = __Name("_G")
local Bool1 = __Name("Bool1")
local Hook1 = __Name("init")
local Hook2 = __Name("_update_check_actions")
local XAudioBuffer = __Name("XAudioBuffer")
local XAudioSource = __Name("XAudioSource")

_G[_GName] = _G[_GName] or {}

local function __ply_ogg(__weapon_tweak_data)
	local __p_category = __weapon_tweak_data.categories[1]
	local __cat2ogg = {
		["shotgun"] = "Shotgun-2.ogg"
	}
	local __this_ogg = ThisModOggs..tostring(__cat2ogg[__p_category])
	if io.file_is_readable(__this_ogg) then
		local this_buffer = XAudio.Buffer:new(__this_ogg)
		local this_source = XAudio.UnitSource:new(XAudio.PLAYER)
		this_source:set_buffer(this_buffer)
		this_source:play()
		_G[_GName][XAudioBuffer] = this_buffer
		_G[_GName][XAudioSource] = this_source
	end
	return
end

local function __end_ogg()
	if _G[_GName][XAudioSource] then
		_G[_GName][XAudioSource]:close(true)
		_G[_GName][XAudioSource] = nil
	end
	if _G[_GName][XAudioBuffer] then
		_G[_GName][XAudioBuffer]:close(true)
		_G[_GName][XAudioBuffer] = nil
	end
	return
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", Hook2, function(self, ...)
	if self:_changing_weapon() then
		self[Bool1] = true
	else
		if self[Bool1] and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
			self[Bool1] = false
			__end_ogg()
			local __weap_base = self._equipped_unit:base()
			local __weapon_tweak_data = __weap_base:weapon_tweak_data()
			__ply_ogg(__weapon_tweak_data)
		end
	end
end)