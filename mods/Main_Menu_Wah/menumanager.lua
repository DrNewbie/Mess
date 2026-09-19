local ThisModPath = ModPath
if blt.xaudio then
	blt.xaudio.setup()
else
	return
end
local ThisModOggsPath = ThisModPath.."sounds/"
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "WW_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local ThisModOggs = {}

Hooks:Add("MenuManagerOnOpenMenu", __Name("MenuManagerOnOpenMenu"), function(self, menu)
	if DelayedCalls and (menu == "menu_main" or menu == "lobby") then
		DelayedCalls:Add(__Name("DelayedCalls"), 3 + math.random()*3, function()
			if table.empty(ThisModOggs) then
				if file.DirectoryExists(ThisModOggsPath) then
					local __files = file.GetFiles(ThisModOggsPath)
					if type(__files) == "table" and not table.empty(__files) then
						for _, __filename in pairs(__files) do
							if __filename and type(__filename) == "string" and string.match(__filename, "%.ogg") then
								if io.file_is_readable(ThisModOggsPath.."/"..__filename) then
									ThisModOggs[__Name(__filename)] = __filename
								end
							end
						end
					end
				end
			end
			local __Ogg = tostring(ThisModOggs[table.random_key(ThisModOggs)])
			if io.file_is_readable(ThisModOggsPath.."/"..__Ogg) then
				XAudio.Source:new(XAudio.Buffer:new(ThisModOggsPath.."/"..__Ogg)):set_volume(1)
			end
		end)
	end
end)