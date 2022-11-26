local ThisModPath = ModPath

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local ThisModOggsPath = ThisModPath.."sounds/"
local ThisModOggs = {}
local __file = file
local __io = io

local function __load_ogg()
	if __file.DirectoryExists(ThisModOggsPath) then
		local __files = __file.GetFiles(ThisModOggsPath)
		if type(__files) == "table" and not table.empty(__files) then
			for _, __filename in pairs(__files) do
				if __filename and type(__filename) == "string" and string.match(__filename, "%.ogg") then
					if __io.file_is_readable(ThisModOggsPath.."/"..__filename) then
						ThisModOggs[Idstring(__filename):key()] = __filename
					end
				end
			end
		end
	end
end

__load_ogg()

local function __ply_ogg()
	local sfx_volume = managers.user:get_setting("sfx_volume")
	local __this_ogg = ThisModOggs[table.random_key(ThisModOggs)]
	if type(__this_ogg) == "string" then
		XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(ThisModOggsPath.."/"..__this_ogg)):set_volume(sfx_volume)
	end
	return
end

local __old_ply = PlayerSound.play

function PlayerSound:play(__vo, ...)
	if type(__vo) == "string" and (__vo == "player_armor_gone_stinger" or __vo == "player_sniper_hit_armor_gone") then
		pcall(__ply_ogg)
	end
	return __old_ply(self, __vo, ...)
end