local ThisModPath = ModPath
local function __Name(__text)
	return "SSS_"..Idstring(tostring(__text)..ThisModPath):key()
end

if _G[__Name(1)] then
	return
else
	_G[__Name(1)] = true
end

local __file = file
local __io = io

local ThisModTexturesPath = ThisModPath.."image/"

local __replace_txt = __io.open(ThisModPath.."replace_list.txt", "r")
local __replace = nil
if __replace_txt then
	__replace = json.decode(__replace_txt:read("*all"))
	__replace_txt = nil
end

local old_get_character_icon = BlackMarketManager.get_character_icon
function BlackMarketManager:get_character_icon(character, ...)
	if __replace and type(__replace[character]) == "string" then
		return __Name(__replace[character])
	end
	return old_get_character_icon(self, character, ...)
end

pcall(function ()
	local ids_texture = Idstring("texture")
	if __file.DirectoryExists(ThisModTexturesPath) then
		local __files = __file.GetFiles(ThisModTexturesPath)
		if type(__files) == "table" and not table.empty(__files) then
			for _, __filename in pairs(__files) do
				if __filename and type(__filename) == "string" and string.match(__filename, "%.texture") then
					if __io.file_is_readable(ThisModTexturesPath.."/"..__filename) then
						local __pic = __Name(__filename)
						local __ids_pic = Idstring(__pic)
						BLTAssetManager:CreateEntry( 
							__ids_pic, 
							ids_texture, 
							ThisModTexturesPath..__filename, 
							nil 
						)
					end
				end
			end
		end
	end
	return
end)