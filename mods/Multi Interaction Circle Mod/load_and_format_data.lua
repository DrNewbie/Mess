local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()

local __Name = function(__id)
	return "YYY_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

if _G[__Name(1)] then return end
_G[__Name(1)] = true

local __file = file
local __io = io

local loaded_data = __Name(2)

_G[loaded_data] = _G[loaded_data] or {}

local function __Load_Data_from_Json()
	local __check_this_directory = {
		[[assets/mod_overrides/]],
		[[mods/]]
	}
	local __loaded_data = {}
	local __identify_this_file = "multi.interaction.circle.json"
	for _, __dir in pairs(__check_this_directory) do
		if __file.DirectoryExists(__dir) then
			local __sub_dirs = __file.GetDirectories(__dir)
			if type(__sub_dirs) == "table" then
				for _, __dir_s in pairs(__sub_dirs) do
					if type(__dir_s) == "string" and __file.DirectoryExists(__dir..__dir_s.."/") and __io.file_is_readable(__dir..__dir_s.."/"..__identify_this_file)  then
						local __data = __io.load_as_json(__dir..__dir_s.."/"..__identify_this_file)
						if type(__data) == "table" and type(__data.identification_code) == "string" and __data.identification_code == "dynamic.interaction.mod" then
							__data.identification_code = nil
							__data.from_this_dir = __dir..__dir_s.."/"
							table.insert(__loaded_data, __data)
						end
					end
				end
			end
		end
	end
	_G[loaded_data] = __loaded_data
	return
end
--[[
	{
		medic_bag(<--- __type) = {
			... <--- __data
		},
		
		ammo_bag = {
			{
				img_name = <string,path>,
				img_chance = <number>			
			}
		}	
	}
]]
local function __Data_Format()
	local __loaded_data = _G[loaded_data]
	local __format_data = {}
	local __now_from_this_dir = ""
	for __i, __d in pairs(__loaded_data) do
		if type(__d) == "table" and type(__d.from_this_dir) == "string" then
			for __type, __data in pairs(__d) do
				if type(__data) == "table" and type(__data.img_name) == "string" then
					local This_Img_Path = __d.from_this_dir.."/"..__data.img_name
					if __io.file_is_readable(This_Img_Path.."active.texture") and __io.file_is_readable(This_Img_Path.."invalid.texture") and __io.file_is_readable(This_Img_Path.."bg.texture") then
						__format_data[__type] = __format_data[__type] or {}
						if type(__data.img_chance) ~= "number" then
							__data.img_chance = 1
						else
							__data.img_chance = math.max(__data.img_chance, 0)
						end
						for __chnace = 1, __data.img_chance do
							table.insert(__format_data[__type], This_Img_Path)
						end
						BLTAssetManager:CreateEntry( 
							__Name(This_Img_Path.."active.texture"), 
							"texture", 
							(This_Img_Path.."active.texture"), 
							nil 
						)
						BLTAssetManager:CreateEntry( 
							__Name(This_Img_Path.."invalid.texture"), 
							"texture", 
							(This_Img_Path.."invalid.texture"), 
							nil 
						)
						BLTAssetManager:CreateEntry( 
							__Name(This_Img_Path.."bg.texture"), 
							"texture", 
							(This_Img_Path.."bg.texture"), 
							nil 
						)
					end
				end
			end		
		end	
	end	
	_G[loaded_data] = __format_data
	return
end

Hooks:PostHook(HUDInteraction, "init", __Name("init:1"), function(self, ...)
	if not _G[__Name(51)] then 
		_G[__Name(51)] = true
		pcall(__Load_Data_from_Json)
		pcall(__Data_Format)
	end
end)