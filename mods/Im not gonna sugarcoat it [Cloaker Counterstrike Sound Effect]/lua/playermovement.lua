local ThisModPath = ModPath

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local __Name = function(__id)
	return "BADMEMES_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local ThisBitmap = __Name("ThisBitmap")
local ThisModOggsPath = ThisModPath.."sounds/"
local ThisModTexturesPath = ThisModPath.."imgs/"
local ThisModOggs = {}
local ThisModTextures = {}
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

local function __load_texture()
	if __file.DirectoryExists(ThisModTexturesPath) then
		local __files = __file.GetFiles(ThisModTexturesPath)
		if type(__files) == "table" and not table.empty(__files) then
			for _, __filename in pairs(__files) do
				if __filename and type(__filename) == "string" and string.match(__filename, "%.texture") then
					if __io.file_is_readable(ThisModTexturesPath.."/"..__filename) then
						local __pic = "memes/"..string.gsub(__filename, ".texture", "")
						local __ids_pic = Idstring(__pic)
						ThisModTextures[Idstring(__filename):key()] = __ids_pic
						BLTAssetManager:CreateEntry( 
							__ids_pic, 
							Idstring("texture"), 
							ThisModTexturesPath.."/"..__filename, 
							nil 
						)
					end
				end
			end
		end
	end
end

pcall(__load_ogg)

pcall(__load_texture)

local function __ply_ogg()
	local sfx_volume = managers.user:get_setting("sfx_volume")
	local __this_ogg = ThisModOggs[table.random_key(ThisModOggs)]
	if type(__this_ogg) == "string" then
		XAudio.UnitSource:new(XAudio.PLAYER, XAudio.Buffer:new(ThisModOggsPath.."/"..__this_ogg)):set_volume(sfx_volume)
	end
	return
end

local function __ply_pic()
	if _G[ThisBitmap] then
		_G[ThisBitmap]:set_visible(true)
	end
	return
end

local function __end_pic()
	if _G[ThisBitmap] then
		_G[ThisBitmap]:set_visible(false)
		local ThisTexture = ThisModTextures[table.random_key(ThisModTextures)]
		if type(ThisTexture) == "string" then
			_G[ThisBitmap]:set_texture(ThisTexture)
		end
	end
	return
end

local function __init_pic()
	if PlayerBase and PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2 and not _G[ThisBitmap] then
		local name1 = __Name("name1")
		local panel1 = __Name("panel1")
		local bitmap1 = __Name("bitmap1")
		local ThisTexture = ThisModTextures[table.random_key(ThisModTextures)]
		if type(ThisTexture) == "userdata" then
			local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
			if hud and hud.panel then
				_G[ThisBitmap] = hud.panel:bitmap({
					texture = ThisTexture,
					layer = 1,
					alpha = 0.5
				})
				_G[ThisBitmap]:set_size(hud.panel:w(), hud.panel:h())
				_G[ThisBitmap]:set_visible(false)
			end
		end
	end
	return
end

Hooks:PostHook(PlayerMovement, "post_init", __Name("Imnotgonnasugarcoatittexture"), function(self)
	pcall(__init_pic)
end)

local old_on_SPOOCed = PlayerMovement.on_SPOOCed

function PlayerMovement:on_SPOOCed(...)
	local __ans = old_on_SPOOCed(self, ...)
	if type(__ans) == "string" and __ans == "countered" then
		pcall(__ply_ogg)
		pcall(__ply_pic)
		DelayedCalls:Add(__Name("on_SPOOCed"), 1, function()
			pcall(__end_pic)
		end)
	end
	return __ans
end