local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("WeaponTweakData:init::"..ThisModIds):key()

if blt.xaudio then
	blt.xaudio.setup()
end

Hooks:PostHook(WeaponTweakData, "init", Hook1, function(self)
	local __pd2_to_tdoll_file = io.open(ThisModPath.."Hooks/gfl_to_pd2_guns_real.json", "r")
	local __pd2_to_tdoll = {}
	if __pd2_to_tdoll_file then
		__pd2_to_tdoll = json.decode(__pd2_to_tdoll_file:read("*all"))
		__pd2_to_tdoll_file:close()
	end
	for __id, __data in pairs(self) do
		if __pd2_to_tdoll[__id] and type(__data) == "table" and type(__data.categories) == "table" and type(__data.use_data) == "table" then
			self[__id].__oath_data = self[__id].__oath_data or {}
			self[__id].__oath_data.__max_points = self[__id].__oath_data.__max_points or 1*20000
			self[__id].__oath_data.__oath_dlc1_wiki_url = "https://iopwiki.com/wiki/"..__pd2_to_tdoll[__id]
			self[__id].__oath_data.__oath_dlc1_ogg_folder = ThisModPath.."Sounds/Default/"..string.upper(__pd2_to_tdoll[__id]).."/"
			self[__id].__oath_data.__oath_link = function(is_click, now_rate)
				if is_click then
					Steam:overlay_activate("url", self[__id].__oath_data.__oath_dlc1_wiki_url)
					if blt.xaudio then
						local __default_ogg_folder = self[__id].__oath_data.__oath_dlc1_ogg_folder
						if file.DirectoryExists(__default_ogg_folder) then
							local __oggs = file.GetFiles(__default_ogg_folder)
							if not table.empty(__oggs) then
								local __p_oggs = {}
								for _, __filename in pairs(__oggs) do
									if __filename and type(__filename) == "string" and string.match(__filename, "%.ogg") then
										__p_oggs[Idstring(__filename):key()] = __default_ogg_folder..__filename
									end
								end
								local __this_ogg = tostring(__p_oggs[table.random_key(__p_oggs)])
								if io.file_is_readable(__this_ogg) then
									if _G.WeaponOathXAudioSource then
										_G.WeaponOathXAudioSource:close(true)
										_G.WeaponOathXAudioSource = nil
									end
									if _G.WeaponOathXAudioBuffer then
										_G.WeaponOathXAudioBuffer:close(true)
										_G.WeaponOathXAudioBuffer = nil
									end
									local this_buffer = XAudio.Buffer:new(__this_ogg)
									local this_source = XAudio.Source:new()
									this_source:set_buffer(this_buffer)
									this_source:play()
									_G.WeaponOathXAudioBuffer = this_buffer
									_G.WeaponOathXAudioSource = this_source
								end
							end
						end
					end
				end
			end
		end
	end
end)