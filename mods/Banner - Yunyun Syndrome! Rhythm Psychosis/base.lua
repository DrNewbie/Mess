local ThisModPath = ModPath

local function __Name(__text)
	return "SSS_"..Idstring(tostring(__text)..ThisModPath):key()
end

if _G[__Name(1)] then
	return
else
	_G[__Name(1)] = true
end

local __io = io
local GameThumbnail = "2914150.dds"

Hooks:PreHook(NewHeistsGui, "init", __Name(2), function(self, ...)
	if __io.file_is_readable(ThisModPath..GameThumbnail) then
		pcall(function ()
			BLTAssetManager:CreateEntry( 
				__Name(GameThumbnail), 
				Idstring("texture"), 
				ThisModPath..GameThumbnail, 
				nil 
			)
			managers.localization:add_localized_strings({
				[__Name(3)] = "Buy [ Yunyun Syndrome!? Rhythm Psychosis ] now"
			})
			local __new_banner_data = {
				name_id = __Name(3),
				texture_path = __Name(GameThumbnail),
				url = "https://store.steampowered.com/app/2914150/"
			}
			local __first_one = tweak_data.gui.new_heists[1]
			tweak_data.gui.new_heists[1] = __new_banner_data
			table.insert(tweak_data.gui.new_heists, __first_one)
		end)
	end
end)