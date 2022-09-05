local ThisModPath = ModPath

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local ThisOGG = ThisModPath.."sounds/earrapelobstermeme.ogg"
if not io.file_is_readable(ThisOGG) then
	return
end

local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "BADMEMES_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local _GName = __Name("_G")
local XAudioBuffer = __Name("XAudioBuffer")
local XAudioSource = __Name("XAudioSource")

_G[_GName] = _G[_GName] or {}

local function __ply_ogg()
	if io.file_is_readable(ThisOGG) then
		local this_buffer = XAudio.Buffer:new(ThisOGG)
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

local ThisBitmap = __Name("ThisBitmap")
_G[ThisBitmap] = _G[ThisBitmap] or nil

if PlayerDamage then
	Hooks:PostHook(PlayerDamage, "on_flashbanged", __Name("on_flashbanged"), function(self)
		__end_ogg()
		__ply_ogg()
		if _G[_GName][XAudioSource] and _G[_GName][XAudioSource]:is_active() then
			if _G[ThisBitmap] then
				_G[ThisBitmap]:set_visible(true)
			end
		end		
	end)
	Hooks:PostHook(PlayerDamage, "update", __Name("update"), function(self)
		if _G[_GName][XAudioSource] and not _G[_GName][XAudioSource]:is_active() then
			__end_ogg()
			if _G[ThisBitmap] then
				_G[ThisBitmap]:set_visible(false)
			end
		end
	end)
	Hooks:PostHook(PlayerDamage, "_stop_tinnitus", __Name("_stop_tinnitus"), function(self)
		__end_ogg()
		if _G[ThisBitmap] then
			_G[ThisBitmap]:set_visible(false)
		end
	end)
end

if HUDManager then
	Hooks:PostHook(HUDManager, "_player_hud_layout", __Name("_player_hud_layout"), function(self)
		local p_load = "packages/badcoollobstermeme"
		if PackageManager:package_exists(p_load) then
			if PackageManager:loaded(p_load) then
				PackageManager:unload(p_load)
			end
			PackageManager:load(p_load)
		else
			return
		end
		local name1 = __Name("name1")
		local panel1 = __Name("panel1")
		local bitmap1 = __Name("bitmap1")
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		self[panel1] = self[panel1] or hud and hud.panel or self._ws:panel({name = name1})
		self[bitmap1] = self[panel1]:bitmap({
			texture = "coollobstermeme",
			color = Color.white:with_alpha(1),
			layer = 1
		})
		self[bitmap1]:set_size(self[panel1]:w(), self[panel1]:h())
		self[bitmap1]:set_visible(false)
		_G[ThisBitmap] = self[bitmap1]
	end)
end