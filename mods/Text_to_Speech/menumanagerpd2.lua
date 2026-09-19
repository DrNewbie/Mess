local ThisModPath = ModPath
local ThisOggPath = ModPath..'__tmp_oggs/'
local ThisFFmpeg = "mods/ffmpeg-exe-dependencies/ffmpeg.exe"

local __BPath = Application:base_path()

local function tts_log(__msg)
	log("[ TTS ]", string.format('%q', tostring(__msg)))
	return
end

if not io.file_is_readable('mods/ffmpeg-exe-dependencies/mod.txt') then
	tts_log("No ThisFFmpeg: "..ThisFFmpeg)
	os.execute(string.format('md "%s"', __BPath..'/mods/ffmpeg-exe-dependencies/'))
	local install_ffmepg = io.open('mods/ffmpeg-exe-dependencies/mod.txt', "w+")
	if install_ffmepg then
		install_ffmepg:write(
		[[
			{
			  "name": "ffmpeg-exe-dependencies",
			  "author": "BtbN/FFmpeg-Builds",
			  "updates": [
				{
				  "identifier": "ffmpeg-exe-dependencies",
				  "host": {
					"meta": "https://drnewbie.github.io/pd2-mods-dependencies/ffmpeg/meta.json"
				  }
				}
			  ]
			}
		]]
		)
		install_ffmepg:close()
	end
	return
end

if blt.xaudio then
	blt.xaudio.setup()
else
	return
end

local __file = file
local __io = io

local function tts_init_folder()
	local __files = __file.GetFiles(ThisOggPath)
	if type(__files) == "table" and not table.empty(__files) then
		for _, __filename in pairs(__files) do
			if __filename and type(__filename) == "string" and string.match(__filename, "%.mp3") then
				if __io.file_is_readable(ThisOggPath.."/"..__filename) then
					os.remove(ThisOggPath.."/"..__filename)
				end
			end
		end
	end
	return
end

tts_init_folder()

local function tts_say(say_line_ids)
	local this_line = ThisOggPath..say_line_ids..".ogg"
	if __io.file_is_readable(this_line) then
		XAudio.Source:new(XAudio.Buffer:new(this_line))
		return true
	end
	return false
end

local function tts_download(say_line, say_voice)
	local this_api = "https://api.soundoftext.com/sounds/"
	local default_data = {
		engine = "Google",
		data = {
			text = say_line or "Hello, world",
			voice = say_voice or "en-US"
		}
	}
	default_data.data.text = string.lower(default_data.data.text)
	default_data.data.text = string.gsub(default_data.data.text,  '[%p%c]', '')
	if tts_say(Idstring(default_data.data.text):key()) then
		--[[ 
			Already done, skip donwload
		]]
		return
	end
	local this_data = json.encode(default_data)
	local this_headers = {
		["Accept"] = "application/json",
		["Content-Type"] = "application/json"
	}
	local payload_content_type = "application/json"
	local this_payload_size = string.len(this_data)
	local function ans_callbackk(error_code, status_code, response_body)
		if type(response_body) == "string" then
			local __j = json.decode(response_body)
			if type(__j) == "table" and __j.success and type(__j.id) == "string" then
				local say_line_ids = Idstring(default_data.data.text):key()
				local this_id = string.format('%q', __j.id)
				this_id = string.gsub(this_id, '"', '')
				tts_log("this_id: "..this_id)
				os.remove(ThisOggPath..say_line_ids..".mp3")
				os.remove(ThisOggPath..say_line_ids..".ogg")
				local mp3_url = "https://files.soundoftext.com/"..this_id..".mp3"
				dohttpreq(mp3_url, 
					function (bin)
						local mp3_file = io.open(ThisOggPath..say_line_ids..".mp3", "wb+")
						if mp3_file then
							mp3_file:write(bin)
							mp3_file:close()
							local __B_MPath = __BPath..'/'..ThisOggPath
							local __ffmpeg_exe = Application:nice_path(__BPath..'/'..ThisFFmpeg, false)
							local __mp3_path = __B_MPath..say_line_ids..".mp3"
							local __ogg_path = __B_MPath..say_line_ids..".ogg"
							assert(
								tostring(
									os.execute(
										string.format('echo "Run Downloader: %s (%s)" & "%s" -i "%s" -c:a libvorbis -q:a 4 "%s"', default_data.data.text, mp3_url, __ffmpeg_exe, __mp3_path, __ogg_path)
									)
								) == '0',
								tostring(
									pcall(tts_say, say_line_ids)
								)
							)
						end
					end
				)
			end
		end
		return
	end
	Steam:http_request_post(this_api, ans_callbackk, payload_content_type, this_data, this_payload_size, this_headers)
	return
end

Hooks:Add("ChatManagerOnReceiveMessage", "TTS_OnReceiveMessage",
	function(channel_id, name, message, color, icon)
		local tts_string = name.." say: "..message
		tts_download(tts_string)
	end
)