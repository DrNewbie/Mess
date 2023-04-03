local ThisModPath = ModPath
local movie_ids = Idstring("movie")
local sound_id = "sounds/metalpipesarmorgonelol"
local sound_ids = Idstring(sound_id)

local function __load_assets()
	BLTAssetManager:CreateEntry(
		sound_ids,
		movie_ids,
		ThisModPath.."sounds/metalpipesarmorgonelol.movie",
		nil
	)
	return
end

pcall(__load_assets)

local function __ply_ogg()
	if not DB:has(movie_ids, sound_ids) or not managers.menu_component then
		return
	end
	local p = managers.menu_component._main_panel
	if alive(p:child("metalpipesarmorgonelol")) then
		managers.menu_component._main_panel:remove(p:child("metalpipesarmorgonelol"))
	end
	local volume = managers.user:get_setting("sfx_volume")
	local percentage = (volume - tweak_data.menu.MIN_SFX_VOLUME) / (tweak_data.menu.MAX_SFX_VOLUME - tweak_data.menu.MIN_SFX_VOLUME)
	managers.menu_component._main_panel:video({
		name = "metalpipesarmorgonelol",
		video = sound_id,
		visible = false,
		loop = false,
	}):set_volume_gain(percentage)
	return
end

local __old_ply = PlayerSound.play

function PlayerSound:play(__vo, ...)
	if type(__vo) == "string" and (__vo == "player_armor_gone_stinger" or __vo == "player_sniper_hit_armor_gone") then
		call_on_next_update(function()
			pcall(__ply_ogg)
		end)
	end
	return __old_ply(self, __vo, ...)
end