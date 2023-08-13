local ThisModPath = ModPath
local __Name = function(__id)
	return "ABC_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local this_file = file

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local __List_of_Sounds = {}

local function __GetSoundFileName(__perk, __cooldown_or_activate)
	__perk = tostring(__perk)
	local __sound_name
	local __perk_dir = ThisModPath.."sounds/"..__perk
	local __type = __cooldown_or_activate and "cooldown" or "activate"
	local __type_patch = __perk_dir.."/"..__type
	if type(__List_of_Sounds[__perk]) == "table" and type(__List_of_Sounds[__perk][__type]) == "table" then
		__sound_name = tostring(table.random(__List_of_Sounds[__perk][__type]))
		if io.file_is_readable(__type_patch.."/"..__sound_name) then
			return __type_patch.."/"..__sound_name
		else
			return
		end
	end
	__List_of_Sounds[__perk] = __List_of_Sounds[__perk] or {}
	__List_of_Sounds[__perk][__type] = __List_of_Sounds[__perk][__type] or {}
	if this_file.DirectoryExists(__type_patch) then
		__List_of_Sounds[__perk][__type] = this_file.GetFiles(__type_patch)
	end
	return __GetSoundFileName(__perk, __cooldown_or_activate)
end

Hooks:PostHook(PlayerManager, "_on_grenade_cooldown_end", __Name(2), function(self)
	if self:player_unit() then
		local __perk, __var2 = managers.blackmarket:equipped_grenade()
		local __sound_name = __GetSoundFileName(__perk, true)
		if __sound_name then
			XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(__sound_name)):set_volume(1)
		end
	end
end)

Hooks:PostHook(PlayerManager, "on_throw_grenade", __Name(3), function(self)
	if self:player_unit() then
		local __perk, __var2 = managers.blackmarket:equipped_grenade()
		local __sound_name = __GetSoundFileName(__perk, false)
		if __sound_name then
			XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(__sound_name)):set_volume(1)
		end
	end
end)

local old_attempt_ability = __Name(4)
PlayerManager[old_attempt_ability] = PlayerManager[old_attempt_ability] or PlayerManager.attempt_ability
function PlayerManager:attempt_ability(__ability, ...)
	local __ans = self[old_attempt_ability](self, __ability, ...)
	if __ans then
		local __sound_name = __GetSoundFileName(__ability, false)
		if __sound_name then
			XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(__sound_name)):set_volume(1)
		end
	end
	return __ans
end