--[[
	0 = Overrides
	1 = Insert
]]
local Insert_Overrides = 0

JokeRssNewsFromNet = JokeRssNewsFromNet or {}

local function GetRssNews(msg_max)
	local url_encode = function (str)
		if (str) then
			str = string.gsub (str, "\n", "\r\n")
			str = string.gsub (str, "([^%w %-%_%.%~])",
				function (c) return string.format ("%%%02X", string.byte(c)) end)
			str = string.gsub (str, " ", "+")
		end
		return str
	end
	local function splitByChunk(text, chunkSize)
		local s = {}
		for i=1, #text, chunkSize do
			s[#s+1] = text:sub(i,i+chunkSize - 1)
		end
		return s
	end
	local full_url = 'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.reddit.com%2Fr%2Fpaydaytheheist%2F.rss'
	
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	
	dohttpreq(full_url, function(data)
		data = tostring(data)
		if data and data:find('feed') and data:find('status') and data:find('items') and data:find('title') then
			data = json.decode(data)
			if tostring(data.status) == 'ok' and type(data.items) == 'table' then
				local _tmp_rss = {
					last_time = os.time(),
					Msg = {}
				}
				local picked = {}
				local items_size = table.size(data.items)
				local pick_amount = msg_max > 0 and math.min(items_size, msg_max) or items_size
				local i_max, i_amount = 100, pick_amount
				while (i_amount > 0 and i_max > 0) do
					i_max = i_max - 1
					local r = math.random(items_size)
					if not picked[r] and data.items[r] and data.items[r].title then
						i_amount = i_amount - 1
						picked[r] = true
						local _msg = splitByChunk(tostring(data.items[r].title), 40)
						for i, v in ipairs(_msg) do
							local _sp_b = false
							if _msg[i+1] and string.len(_msg[i+1]) <= 3 then
								v = v .. _msg[i+1]
								_sp_b = true
							else
								v = v .. ' ...'
							end
							table.insert(_tmp_rss.Msg, string.format('%q', v))
							if _sp_b then
								break								
							end
						end
					end
				end
				if _tmp_rss.Msg and _tmp_rss.Msg[1] then
					JokeRssNewsFromNet = {
						last_time = _tmp_rss.last_time,
						Msg = _tmp_rss.Msg
					}
					local _filesss = io.open("mods/RSSNews2ModsList/RSSNews.txt", "w+")
					if _filesss then
						_filesss:write(json.encode(JokeRssNewsFromNet))
						_filesss:close()
					end
				end
			end
		else
			log('[RSS]: Fail to get dates')
		end
	end)
end

local function UpdateRssNews()
	local _filesss = io.open("mods/RSSNews2ModsList/RSSNews.txt", "r")
	if _filesss then
		local _data = tostring(_filesss:read("*all"))
		if not string.is_nil_or_empty(_data) then
			JokeRssNewsFromNet = json.decode(_data)
		end
		_filesss:close()
	else
		_filesss = io.open("mods/RSSNews2ModsList/RSSNews.txt", "w+")
		if _filesss then
			_filesss:write(json.encode({last_time = os.time(), Msg = {'Init'}}))
			_filesss:close()
		end
	end
	JokeRssNewsFromNet.last_time = JokeRssNewsFromNet.last_time or 0
	if os.difftime(os.time(), JokeRssNewsFromNet.last_time) > 10800 or not JokeRssNewsFromNet.Msg or not JokeRssNewsFromNet.Msg[1] then
		GetRssNews(-1)
	end
end

Hooks:Add('MenuManagerOnOpenMenu', 'JokeRssNewsFromNet_RunInitNow', function(self, menu, ...)
	if menu == 'menu_main' or menu == 'lobby' then
		DelayedCalls:Add('JokeRssNewsFromNet_RunInitNow_Delay', 3, function()
			UpdateRssNews()
		end)
	end
end)

local RSS_MenuCallbackHandler_build_mods_list = MenuCallbackHandler.build_mods_list

function MenuCallbackHandler:build_mods_list()
	local ori_mod = RSS_MenuCallbackHandler_build_mods_list(self)
	local msg_ready = JokeRssNewsFromNet and JokeRssNewsFromNet.Msg and JokeRssNewsFromNet.Msg[1] and true or false
	if Insert_Overrides == 0 then
		ori_mod = {}
	end
	if msg_ready then
		for _, v in pairs(JokeRssNewsFromNet.Msg) do
			v = tostring(v)
			table.insert(ori_mod, {v, v})
		end
	else
		UpdateRssNews()
	end
	return ori_mod
end