_G.LazyYoutubeMusicGeneratorMain = _G.LazyYoutubeMusicGeneratorMain or {}
_G.LazyYoutubeMusicGeneratorMain.ModPath = _G.LazyYoutubeMusicGeneratorMain.ModPath or ModPath
_G.LazyYoutubeMusicGeneratorMain.Download = function(ThisDL_ID)
	local __YPMF = _G.LazyYoutubeMusicGeneratorMain
	local ThisModPath = __YPMF.ModPath
	local ThisDL_URL = 'https://www.youtube.com/watch?v='..ThisDL_ID
	local __BPath = Application:base_path()
	local __B_MPath = __BPath..'/'..ThisModPath
	--local __dump_json = ThisModPath..'__dump.json'
	local __ffmpeg_exe = Application:nice_path(__B_MPath.."/ffmpeg.exe", false)
	local __ogg_folder = Application:nice_path(__B_MPath..'/__tmp_oggs/', false)
	os.execute(string.format('rd /S /Q "%s"', __ogg_folder))
	os.execute(string.format('md "%s"', __ogg_folder))
	--os.remove(__dump_json)
	--os.execute(tostring(string.format('yt-dlp.exe --quiet --no-warnings --simulate --dump-json "%s" >> "%s"', 'https://www.youtube.com/watch?v=w2HR1aUvJGs', __dump_json)))
	local __to_MusicMod = function(__path, __yt_id)
		__path = tostring(__path)
		__yt_id = tostring(__yt_id)
		if not file.DirectoryExists(__path) then
			return "LazyYoutubeMusicGenerator: not file.DirectoryExists(__path)"
		else
			local __files = file.GetFiles(__path)
			if type(__files) ~= "table" or table.empty(__files) then
				return "LazyYoutubeMusicGenerator: not file.GetFiles(__path)"
			else
				local __VideoInfoFile = io.open(ThisModPath..'/__tmp_oggs/'..ThisDL_ID..'.info.json', 'r')
				if __VideoInfoFile then
					local __VideoInfoJson = json.decode(__VideoInfoFile:read("*all"))
					__VideoInfoFile:close()
					if type(__VideoInfoJson) == "table" and not table.empty(__VideoInfoJson) and type(__VideoInfoJson.id) == "string" and __VideoInfoJson.id == __yt_id and type(__VideoInfoJson.title) == "string" then
						local __music_mod_name = '[Music] '..__yt_id
						local __music_mod_path = __BPath..'/mods/'..__music_mod_name..'/'
						local __music_mod_path_nice = Application:nice_path(__music_mod_path, false)
						
						--[[ creat folder ]]
						os.execute(string.format('rd /S /Q "%s"', __music_mod_path_nice))
						os.execute(string.format('md "%s"', __music_mod_path_nice))
						os.execute(string.format('md "%s"', __music_mod_path_nice..'/loc/'))
						os.execute(string.format('md "%s"', __music_mod_path_nice..'/sounds/'))
						
						--[[ music name file and info ]]
						local __music_mod_name_to_file_path = __music_mod_path..'/'..__VideoInfoJson.title..'.txt'
						local __music_mod_name_to_file = io.open(__music_mod_name_to_file_path, 'w+')
						if __music_mod_name_to_file then
							__music_mod_name_to_file:write(json.encode(__VideoInfoJson))
							__music_mod_name_to_file:close()
						end
						
						--[[ main.xml ]]
						local __music_mod_main_xml_path = __music_mod_path..'/main.xml'
						local __music_mod_main_xml = io.open(__music_mod_main_xml_path, 'w+')
						if __music_mod_main_xml then
							__music_mod_main_xml:write('<table name="'..__music_mod_name..'"> \n')
							__music_mod_main_xml:write('    <Localization directory="loc" default="en.json"/> \n')
							__music_mod_main_xml:write('    <MenuMusic id="yt_'..__yt_id..'" source="sounds/'..__yt_id..'.ogg"/> \n')
							__music_mod_main_xml:write('</table> \n')
							__music_mod_main_xml:close()
						end
						
						--[[ write loc file ]]
						local __music_mod_loc_path = __music_mod_path..'/loc/en.json'
						local __music_mod_loc = io.open(__music_mod_loc_path, 'w+')
						if __music_mod_loc then
							local __tmp_loc = {
								["menu_jukebox_yt_"..__yt_id..""] = __VideoInfoJson.title,
								["menu_jukebox_screen_yt_"..__yt_id..""] = __VideoInfoJson.title
							}
							__music_mod_loc:write(json.encode(__tmp_loc))
							__music_mod_loc:close()
							--managers.localization:add_localized_strings(__tmp_loc)
						end
						
						--[[ copy ogg ]]
						local __ogg_from_nice = Application:nice_path(__path..'/'..__yt_id..'.ogg', false)
						local __ogg_to_nice = Application:nice_path(__music_mod_path_nice..'/sounds/', false)
						os.execute(string.format('copy /Y "%s" "%s"', __ogg_from_nice, __ogg_to_nice))
						
						--[[ Load into Game ]]
						if ModCore then
							--ModCore:new(__music_mod_main_xml_path, true, true)
						end
						
						--[[ remove __tmp ]]
						os.execute(string.format('rd /S /Q "%s"', __path))
						
						return "LazyYoutubeMusicGenerator: okay"
					end
				end
			end
		end
		return "LazyYoutubeMusicGenerator: no run"
	end
	assert(
		tostring(
			os.execute(
				string.format('yt-dlp.exe --quiet --no-warnings --write-info-json --extract-audio --audio-format vorbis --ffmpeg-location "%s" --paths "%s" --output "%s" "%s"', __ffmpeg_exe, __ogg_folder, "%(id)s.%(ext)s", ThisDL_URL)
			)
		) == '0',
		tostring(
			pcall(__to_MusicMod, __ogg_folder, ThisDL_ID)
		)
	)
	return
end