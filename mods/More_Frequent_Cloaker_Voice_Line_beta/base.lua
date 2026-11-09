if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local IS_DEBUG_LOL = false

local ThisModPath = ModPath

local ThisModOggPath = ModPath.."/sounds/"

local __Name = function(...)
	return "X_"..Idstring( tostring(json.encode({...})) .. tostring(ThisModPath) ):key()
end

local this_file = file

local this_io = io

local __Voices = {
	["Death_or_Hurt_Short"] = this_file.DirectoryExists(ThisModOggPath.."Death_or_Hurt_Short") and this_file.GetFiles(ThisModOggPath.."Death_or_Hurt_Short") or {},
	
	["Hit_by_Flashbang"] = this_file.DirectoryExists(ThisModOggPath.."Hit_by_Flashbang") and this_file.GetFiles(ThisModOggPath.."Hit_by_Flashbang") or {},
	
	["Hurt_Long"] = this_file.DirectoryExists(ThisModOggPath.."Hurt_Long") and this_file.GetFiles(ThisModOggPath.."Hurt_Long") or {},
	
	["Hurt_Short"] = this_file.DirectoryExists(ThisModOggPath.."Hurt_Short") and this_file.GetFiles(ThisModOggPath.."Hurt_Short") or {},
	
	["Player_Cuffed"] = this_file.DirectoryExists(ThisModOggPath.."Player_Cuffed") and this_file.GetFiles(ThisModOggPath.."Player_Cuffed") or {},
	
	["Taunting_Hard"] = this_file.DirectoryExists(ThisModOggPath.."Taunting_Hard") and this_file.GetFiles(ThisModOggPath.."Taunting_Hard") or {},
	
	["Taunting_Peace"] = this_file.DirectoryExists(ThisModOggPath.."Taunting_Peace") and this_file.GetFiles(ThisModOggPath.."Taunting_Peace") or {},
	
	True
}

local __PlaySoundOne = function(this_unit, __type)
	if not this_unit or not alive(this_unit) then
		return -1
	end
	if not __type or type(__type) ~= "string" or not __Voices[__type] or type(__Voices[__type]) ~= "table" or table.empty(__Voices[__type]) then
		return -2
	end
	local this_ogg = ThisModOggPath.."/"..__type.."/"..__Voices[__type][table.random_key(__Voices[__type])]
	if this_io.file_is_readable(this_ogg) then
		XAudio.UnitSource:new(this_unit, XAudio.Buffer:new(this_ogg)):set_volume(1)
		return 1
	end
	return -3
end

local __is_this_unit_okay = function(this_unit)
	if this_unit and alive(this_unit) and this_unit:base()._tweak_table == "spooc" and managers.enemy and managers.enemy:is_enemy(this_unit) then
		return true
	end
	return false
end

local __delay_t_max = 10

local __global_delay = __Name('__global_delay')

Hooks:PostHook(CopMovement, "update", __Name(1), function(self, __unit, __t, __dt)
	if not __is_this_unit_okay(self._unit) then
		return
	end	
	if type(self[__global_delay]) ~= "number" then
		self[__global_delay] = __delay_t_max + math.random() * __delay_t_max
	else
		if self[__global_delay] > 0 then
			self[__global_delay] = self[__global_delay] - __dt
		else
			self[__global_delay] = nil
			pcall(__PlaySoundOne, self._unit, table.random({"Hit_by_Flashbang", "Hurt_Long", "Taunting_Hard"}))
		end
	end
end)