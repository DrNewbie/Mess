local ThisModTexturesPath = ModPath.."imgs/noob_hud/"
local __file = file
local __io = io

local function LoadAssetsFunction()
	if __file.DirectoryExists(ThisModTexturesPath) then
		local __files = __file.GetFiles(ThisModTexturesPath)
		if type(__files) == "table" and not table.empty(__files) then
			for _, __filename in pairs(__files) do
				if __filename and type(__filename) == "string" and string.match(__filename, "%.texture") then
					if __io.file_is_readable(ThisModTexturesPath.."/"..__filename) then
						local __pic = "noob_hud/"..string.gsub(__filename, ".texture", "")
						local __ids_pic = Idstring(__pic)
						BLTAssetManager:CreateEntry( 
							__ids_pic, 
							Idstring("texture"), 
							ThisModTexturesPath..__filename, 
							nil 
						)
					end
				end
			end
		end
	end
	return
end

pcall(LoadAssetsFunction)