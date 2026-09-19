local ThisModPath = ModPath
if blt.xaudio then
	blt.xaudio.setup()
else
	return
end
local ThisModOggsPath = ThisModPath.."sounds/"
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "KISAR_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModOggs = {}

tweak_data.blackmarket.projectiles["chico_injector"].sounds.activate = nil

Hooks:PostHook(PlayerManager, "activate_temporary_upgrade", __Name("activate_temporary_upgrade"), function(self, __var1, __var2)
	if __var1 and __var2 and __var1 == "temporary" and __var2 == "chico_injector" then	
		if table.empty(ThisModOggs) and file.DirectoryExists(ThisModOggsPath) then
			local __files = file.GetFiles(ThisModOggsPath)
			if type(__files) == "table" and not table.empty(__files) then
				for _, __filename in pairs(__files) do
					if __filename and type(__filename) == "string" and string.match(__filename, "%.ogg") and io.file_is_readable(ThisModOggsPath.."/"..__filename) then
						ThisModOggs[__Name(__filename)] = __filename
					end
				end
			end
		end
		local __Ogg = ThisModOggsPath.."/"..tostring(ThisModOggs[table.random_key(ThisModOggs)])
		if io.file_is_readable(__Ogg) then
			XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(__Ogg)):set_volume(1)
		end
	end
end)