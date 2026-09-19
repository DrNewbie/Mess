local ThisModPath = ModPath
local ThisOGG = ThisModPath.."loud.ogg"

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

if not io.file_is_readable(ThisOGG) then
	return
end

local function __ply_ogg(__unit)
	__unit = __unit and alive(__unit) and __unit or XAudio.PLAYER
	XAudio.UnitSource:new(__unit, XAudio.Buffer:new(ThisOGG)):set_volume(1)
	return
end

local old_heal_unit = MedicDamage.heal_unit

function MedicDamage:heal_unit(__heal_unit, ...)
	local __ans = old_heal_unit(self, __heal_unit, ...)
	if __ans then
		pcall(__ply_ogg, __heal_unit)
	end
	return __ans
end