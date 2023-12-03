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

local __new_banner = __io.open(ThisModPath.."__new_banner.txt", "r")
local __new_banner_data = nil
if __new_banner then
	__new_banner_data = json.decode(__new_banner:read("*all"))
	__new_banner = nil
end

Hooks:PreHook(NewHeistsGui, "init", __Name(1), function(self, ...)
	pcall(function ()
		local ids_texture = Idstring("texture")
		local __new_banner = {limit = 5}
		if __file.DirectoryExists(ThisModTexturesPath) then
			local __files = __file.GetFiles(ThisModTexturesPath)
			if type(__files) == "table" and not table.empty(__files) then
				for _, __filename in pairs(__files) do
					if __filename and type(__filename) == "string" and string.match(__filename, "%.texture") then
						if __io.file_is_readable(ThisModTexturesPath.."/"..__filename) then
							local __pic = __Name(__filename)
							local __ids_pic = Idstring(__pic)
							local __ids_pic_key = __ids_pic:key()
							BLTAssetManager:CreateEntry( 
								__ids_pic, 
								ids_texture, 
								ThisModTexturesPath..__filename, 
								nil 
							)
							local __base_banner = {
								name_id = "bm_menu_buy_dlc",
								texture_path = __pic,
								url = "https://modworkshop.net/?"..__ids_pic_key
							}
							if type(__new_banner_data[__filename]) == "table" then
								local __try_data = __new_banner_data[__filename]
								if type(__try_data.name_id) == "string" then
									__base_banner.name_id = __try_data.name_id
									if type(__try_data[__try_data.name_id]) == "string" then
										managers.localization:add_localized_strings({
											[__try_data.name_id] = __try_data[__try_data.name_id]
										})
									end
								end
								if type(__try_data.texture_path) == "string" then
									__base_banner.texture_path = __try_data.texture_path
								end
								if type(__try_data.url) == "string" then
									__base_banner.url = __try_data.url
								end
								table.insert(__new_banner, __base_banner)
							end
						end
					end
				end
			end
		end
		if type(__new_banner) == "table" and not table.empty(__new_banner) and #__new_banner > 0 then
			tweak_data.gui.new_heists = __new_banner
		end
	end)
end)