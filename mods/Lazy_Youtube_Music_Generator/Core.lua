_G.LazyYoutubeMusicGeneratorMain = _G.LazyYoutubeMusicGeneratorMain or {}
_G.LazyYoutubeMusicGeneratorMain.ModPath = _G.LazyYoutubeMusicGeneratorMain.ModPath or ModPath
_G.LazyYoutubeMusicGeneratorMain.Download = function(ThisDL_ID)

	local __YPMF = _G.LazyYoutubeMusicGeneratorMain
	local ThisModPath = __YPMF.ModPath
	local ThisDL_URL = 'https://www.youtube.com/watch?v='..ThisDL_ID
	local __BPath = Application:base_path()
	local __B_MPath = __BPath..'/'..ThisModPath
	local __ffmpeg_exe = Application:nice_path(__B_MPath.."/ffmpeg.exe", false)
	local __yt_dlp_exe = Application:nice_path(__B_MPath.."/yt-dlp.exe", false)
	local __ogg_folder = Application:nice_path(__B_MPath..'/__tmp_oggs/', false)
	os.execute(string.format('rd /S /Q "%s"', __ogg_folder))
	os.execute(string.format('md "%s"', __ogg_folder))
		
	local __to_MusicMod = function(__path, __yt_id)
		__path = tostring(__path)
		__yt_id = tostring(__yt_id)
		
		if not file.DirectoryExists(__path) then
			log("LazyYoutubeMusicGenerator: not file.DirectoryExists(__path)")
			return
		end
		
		local __files = file.GetFiles(__path)
		if type(__files) ~= "table" or table.empty(__files) then
			log("LazyYoutubeMusicGenerator: not file.GetFiles(__path)")
			return
		end
		
		local __VideoInfoFile = io.open(ThisModPath..'/__tmp_oggs/'..ThisDL_ID..'.info.json', 'r')
		if not __VideoInfoFile then
			log("LazyYoutubeMusicGenerator: no run, not __VideoInfoFile")
			return
		end
		
		local __VideoInfoJson = json.decode(__VideoInfoFile:read("*all"))
		
		__VideoInfoFile:close()
		if type(__VideoInfoJson) ~= "table" or table.empty(__VideoInfoJson) or type(__VideoInfoJson.id) ~= "string" or __VideoInfoJson.id ~= __yt_id or type(__VideoInfoJson.title) ~= "string" then
			log("LazyYoutubeMusicGenerator: no run, not __VideoInfoFile type")
			return
		end
		
		local __music_mod_name = '[Music] '..__yt_id
		local __music_mod_path = __BPath..'/mods/'..__music_mod_name..'/'
		local __music_mod_path_nice = Application:nice_path(__music_mod_path, false)
		
		--[[ creat folder ]]
		os.execute(string.format('rd /S /Q "%s"', __music_mod_path_nice))
		os.execute(string.format('md "%s"', __music_mod_path_nice))
		os.execute(string.format('md "%s"', __music_mod_path_nice..'/loc/'))
		os.execute(string.format('md "%s"', __music_mod_path_nice..'/sounds/'))
		
		--[[ music name file and info ]]
		local __music_mod_name_to_file_path = Application:nice_path(__music_mod_path..'/info.json', false)
		if io.file_is_readable(__music_mod_name_to_file_path) then
			os.remove(__music_mod_name_to_file_path)
		end
		local tmp_data = {
			title = tostring(__VideoInfoJson.title),
			uploader_url = tostring(__VideoInfoJson.uploader_url),
			webpage_url = tostring(__VideoInfoJson.webpage_url)
		}
		pcall(io.save_as_json, tmp_data, __music_mod_name_to_file_path)
		
		--[[ main.xml ]]
		local __music_mod_main_xml_path = Application:nice_path(__music_mod_path..'/main.xml', false)
		if io.file_is_readable(__music_mod_main_xml_path) then
			os.remove(__music_mod_main_xml_path)
		end
		local __music_mod_main_xml = io.open(__music_mod_main_xml_path, 'w+')
		if __music_mod_main_xml then
			__music_mod_main_xml:write('<table name="'..__music_mod_name..'"> \n')
			__music_mod_main_xml:write('    <Localization directory="loc" default="en.json"/> \n')
			__music_mod_main_xml:write('    <MenuMusic id="yt_'..__yt_id..'" source="sounds/'..__yt_id..'.ogg"/> \n')
			__music_mod_main_xml:write('</table> \n')
			__music_mod_main_xml:close()
		end

		--[[ write loc file ]]
		local __music_mod_loc_path = Application:nice_path(__music_mod_path..'/loc/en.json', false)
		if io.file_is_readable(__music_mod_loc_path) then
			os.remove(__music_mod_loc_path)
		end
		pcall(io.save_as_json, {["menu_jukebox_yt_"..__yt_id..""] = __VideoInfoJson.title, ["menu_jukebox_screen_yt_"..__yt_id..""] = __VideoInfoJson.title}, __music_mod_loc_path)
		
		--[[ copy ogg ]]
		local __ogg_from_nice = Application:nice_path(__path..'/'..__yt_id..'.ogg', false)
		local __ogg_to_nice = Application:nice_path(__music_mod_path_nice..'/sounds/', false)
		if io.file_is_readable(__ogg_to_nice) then
			os.remove(__ogg_to_nice)
		end
		os.execute(string.format('copy /Y "%s" "%s"', __ogg_from_nice, __ogg_to_nice))
		
		--[[ Load into Game ]]
		if ModCore then
			--ModCore:new(__music_mod_main_xml_path, true, true)
		end
		
		--[[ remove __tmp ]]
		os.execute(string.format('rd /S /Q "%s"', __path))
		
		return true
	end
	Global.YT_DLP_UPDATE_DELY_TIME = Global.YT_DLP_UPDATE_DELY_TIME or nil
	local is_update_again = false
	if not Global.YT_DLP_UPDATE_DELY_TIME or os.difftime(os.time(), Global.YT_DLP_UPDATE_DELY_TIME) > 600 then
		Global.YT_DLP_UPDATE_DELY_TIME = os.time()
		is_update_again = true
	end
	if is_update_again then
		assert(
			tostring(
				os.execute(
					string.format('echo "Run PD2 LazyYoutubeMusicGenerator" & "%s" -U & "%s" --quiet --no-warnings --write-info-json --extract-audio --audio-format vorbis --ffmpeg-location "%s" --paths "%s" --output "%s" "%s"', __yt_dlp_exe, __yt_dlp_exe, __ffmpeg_exe, __ogg_folder, "%(id)s.%(ext)s", ThisDL_URL)
				)
			) == '0',
			tostring(
				pcall(__to_MusicMod, __ogg_folder, ThisDL_ID)
			)
		)
	else
		assert(
			tostring(
				os.execute(
					string.format('echo "Run PD2 LazyYoutubeMusicGenerator" & "%s" --quiet --no-warnings --write-info-json --extract-audio --audio-format vorbis --ffmpeg-location "%s" --paths "%s" --output "%s" "%s"', __yt_dlp_exe, __ffmpeg_exe, __ogg_folder, "%(id)s.%(ext)s", ThisDL_URL)
				)
			) == '0',
			tostring(
				pcall(__to_MusicMod, __ogg_folder, ThisDL_ID)
			)
		)
	end
	return
end