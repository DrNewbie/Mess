_G.MWSUpdateBanner = _G.MWSUpdateBanner or {}

MWSUpdateBanner.ModPath = ModPath

MWSUpdateBanner.CachePath = MWSUpdateBanner.ModPath..'cache/'

MWSUpdateBanner.ppath = {}

local PANEL_PADDING = 10
local IMAGE_H = 123
local IMAGE_W = 416
local TIME_PER_PAGE = 6
local CHANGE_TIME = 0.5
local SPOT_W = 32
local SPOT_H = 8
local BAR_W = 32
local BAR_H = 6
local BAR_X = (SPOT_W - BAR_W) / 2
local BAR_Y = 0

--[[
	Credit to Egor Skriptunoff ; https://stackoverflow.com/a/23592008
]]
function MWSUpdateBanner:ReadHTML(text_with_URLs)
	local ans_did_key = {}
	local ans_pic = {}
	local ans_did = {}
	
	local domains = [[.net]]
	local tlds = {}
	for tld in domains:gmatch'%w+' do
		tlds[tld] = true
	end
	local function max4(a,b,c,d) return math.max(a+0, b+0, c+0, d+0) end
	local protocols = {[''] = 0, ['http://'] = 0, ['https://'] = 0, ['ftp://'] = 0}
	local finished = {}
	for pos_start, url, prot, subd, tld, colon, port, slash, path in
		text_with_URLs:gmatch'()(([%w_.~!*:@&+$/?%%#-]-)(%w[-.%w]*%.)(%w+)(:?)(%d*)(/?)([%w_.~!*:@&%;+$/?%%#=-]*))'
	do
		if protocols[prot:lower()] == (1 - #slash) * #path and not subd:find'%W%W'
			and (colon == '' or port ~= '' and port + 0 < 65536)
			and (tlds[tld:lower()] or tld:find'^%d+$' and subd:find'^%d+%.%d+%.%d+%.$'
			and max4(tld, subd:match'^(%d+)%.(%d+)%.(%d+)%.$') < 256)
		then
			finished[pos_start] = true
			if not ans_did[Idstring(url):key()] and url:find('mydownloads') and url:find('did=') then
				ans_did[Idstring(url):key()] = true
				ans_did_key[#ans_did] = url:match('(%d+)')
			elseif url:find('modworkshop.net/mydownloads/previews/') then
				ans_pic[Idstring(url):key()] = {url = url, key = ans_did_key[#ans_did_key]}
			end
		end
	end
	local rans_pic = {}
	for _, d in pairs(ans_pic) do
		table.insert(rans_pic, d)
	end
	local shuffle = function(tbl)
		local len, random = #tbl, math.random 
		for i = len, 2, -1 do
			local j = random( 1, i )
			tbl[i], tbl[j] = tbl[j], tbl[i]
		end
		return tbl
	end
	rans_pic = shuffle(rans_pic)
	return rans_pic
end

function MWSUpdateBanner:DelAllCache()
	local plss = file.GetFiles(self.CachePath)
	self.ppath = {}
	for _, picpath in pairs(plss) do
		picpath = self.CachePath..picpath
		os.remove(picpath)
	end
end

function MWSUpdateBanner:Load4Cache(picpath)
	if SystemFS:exists(Application:nice_path(picpath, true)) then
		local new_textures = {}
		local type_texture_id = Idstring("texture")
		local texture_id = Idstring(picpath)
		DB:create_entry(type_texture_id, texture_id, picpath)
		table.insert(new_textures, texture_id)
		Application:reload_textures(new_textures)
		table.insert(self.ppath, picpath)
	end
end

function MWSUpdateBanner:LoadALLCache()
	local plss = file.GetFiles(self.CachePath)
	if table.size(plss) < 1 then
		return
	end
	self.ppath = {}
	for _, picpath in pairs(plss) do
		picpath = self.CachePath..picpath
		if SystemFS:exists(Application:nice_path(picpath, true)) then
			self:Load4Cache(picpath)
		end
	end
end

function MWSUpdateBanner:ResizeALLCache()
	local plss = file.GetFiles(self.CachePath)
	if table.size(plss) < 1 then
		return
	end
	local _pkey = 1
	local basepath = Application:base_path()
	local exepath = basepath.."//"..self.ModPath.."/py"
	local base_CachePath = basepath.."/"..self.CachePath
	for _, picpath in pairs(plss) do
		if SystemFS:exists(Application:nice_path(self.CachePath..picpath, true)) then
			local inputf = Application:nice_path(base_CachePath..picpath, false)
			local outputf = Application:nice_path(base_CachePath..picpath..'_re.png', false)
			local exec_cmd = '"'.."\""..Application:nice_path(exepath.."\\", true).."img_resize.exe\" \""..inputf.."\" \""..outputf.."\" "..IMAGE_W.." "..IMAGE_H.." & del \""..inputf.."\""..'"'
			DelayedCalls:Add(Idstring('MWSUpdateBanner:Load4Cache()&:Go_'..picpath):key(), 5 * _pkey, function()
				os.execute(exec_cmd)
			end)
		end
		_pkey = _pkey + 1
	end
end

function MWSUpdateBanner:LoopTime4ResizeALLCache()
	local plss = file.GetFiles(self.CachePath)
	if table.size(plss) >= 1 then
		for _, picpath in pairs(plss) do
			local ppic = io.open(self.CachePath..picpath, 'r')
			if ppic then
				if tonumber(ppic:seek("end")) > 3 * 1024 then
					ppic:close()
					DelayedCalls:Add(Idstring('MWSUpdateBanner:self:ResizeALLCache()'):key(), 6, function()
						MWSUpdateBanner:ResizeALLCache()
					end)
					return
				end
				ppic:close()
			end
		end
	end
	DelayedCalls:Add(Idstring('MWSUpdateBanner:Loop()'):key(), 1, function()
		MWSUpdateBanner:LoopTime4ResizeALLCache()
	end)
end

function MWSUpdateBanner:Save2Cache(purl, did_id)
	dohttpreq(purl, 
		function (PICFromWebNow_page)
			self.pkey = self.pkey + 1
			local _pkey = self.pkey
			local toosmall = {}
			local pname = _pkey..'.'..did_id..'.png'
			local picpath = self.CachePath..pname
			local phash = "1x"
			local ppic = io.open(picpath, 'wb+')
			if ppic then
				ppic:write(PICFromWebNow_page)
				phash = Idstring(tostring(PICFromWebNow_page)):key()
				if tonumber(ppic:seek("end")) < 3 * 1024 then
					table.insert(toosmall, picpath)
				end
				ppic:close()
			end
			for _, delthis in pairs(toosmall) do
				os.remove(delthis)
			end
			DelayedCalls:Add(Idstring('MWSUpdateBanner:Loop()'):key(), 1, function()
				MWSUpdateBanner:LoopTime4ResizeALLCache()
			end)
		end
	)
end

function MWSUpdateBanner:RunInitNow()
	if not DelayedCalls then
		return
	end
	self:DelAllCache()
	self.PictureList = {"Na"}
	DelayedCalls:Add(Idstring('MWSUpdateBanner:ModsList:CC_'..tostring(os.time())):key(), 2.5, function()
		local uurl = "https://modworkshop.net/mydownloads.php?action=latest"
		dohttpreq(uurl, 
			function (uurl_page)
				uurl_page = tostring(uurl_page):lower()
				local pic_list = self:ReadHTML(uurl_page)
				self.pkey = 0
				for i_key, pic_data in pairs(pic_list) do
					DelayedCalls:Add(Idstring('MWSUpdateBanner:Save2Cache:CC_'..i_key):key(), i_key * 0.5, function()
						self:Save2Cache(pic_data.url, pic_data.key)
					end)
					if i_key > 5 then
						break
					end
				end
			end
		)
	end)
end

function MWSUpdateBanner:GetModsMWSID(_current_page)
	local _, mws_id = tostring(self.ppath[_current_page]):match('(%d+).(%d+)')
	return tostring(mws_id)
end

function MWSUpdateBanner:UpdateModsName(_current_page)
	self.mod_name = self.mod_name or {}
	local mws_id = self:GetModsMWSID(_current_page)
	dohttpreq("https://modworkshop.net/mydownloads.php?action=view_down&did="..mws_id, 
		function (uurl_page)
			uurl_page = tostring(uurl_page)
			local mod_name, _ = tostring(string.match(uurl_page, '<title>(.*)-(.*)</title>'))
			MWSUpdateBanner.mod_name[_current_page] = mod_name
		end
	)
end

function MWSUpdateBanner:GetModsName(_current_page)
	self.mod_name = self.mod_name or {}
	return tostring(self.mod_name[_current_page])
end

Hooks:Add('MenuManagerOnOpenMenu', 'MWSUpdateBannerFunctionInit', function(self, menu)
	if DelayedCalls and (menu == 'menu_main' or menu == 'lobby') then
		DelayedCalls:Add(Idstring('MWSUpdateBanner:RunInitNow()&Go'):key(), 5, function()
			MWSUpdateBanner.last_time = MWSUpdateBanner.last_time or 0
			local _filesss = io.open(MWSUpdateBanner.ModPath.."_tmp.txt", "r")
			if _filesss then
				local _data = tostring(_filesss:read("*all"))
				_filesss:close()
				local _data_tbl = json.decode(_data)
				if type(_data_tbl) == "table" and type(_data_tbl.last_time) == "number" then
					MWSUpdateBanner.last_time = _data_tbl.last_time
				end
			end
			if os.difftime(os.time(), MWSUpdateBanner.last_time) > 10800 then
				_filesss = io.open(MWSUpdateBanner.ModPath.."_tmp.txt", "w+")
				if _filesss then
					_filesss:write(json.encode({last_time = os.time()}))
					_filesss:close()
				end
				MWSUpdateBanner:RunInitNow()
			end
		end)
	end
end)

function NewHeistsGui:init(ws, fullscreen_ws)
	MWSUpdateBanner:LoadALLCache()

	local tweak = tweak_data.gui.new_heists
	self._page_count = math.min(#tweak, tweak.limit)
	self._current_page = 1
	self._block_change = false
	self._highlighted = false
	self._ws = ws
	self._fullscreen_ws = fullscreen_ws
	self._panel = ws:panel()
	self._full_panel = fullscreen_ws:panel()
	self._content_panel = self._full_panel:panel({
		w = IMAGE_W
	})

	self._content_panel:set_right(self._panel:width())

	local header_h = tweak_data.menu.pd2_small_font_size + PANEL_PADDING
	self._contents = {}
	self._internal_content_panel = self._content_panel:panel()
	self._internal_image_panel = self._internal_content_panel:panel({
		y = header_h,
		h = IMAGE_H
	})
	local max_h = 0
	self._font_size = tweak_data.menu.pd2_small_font_size
	self._text = self._internal_content_panel:text({
		text = "ASDF",
		font = tweak_data.menu.pd2_small_font,
		font_size = self._font_size,
		y = PANEL_PADDING - 5
	})
	
	self:_set_text(managers.localization:to_upper_text(tweak[1].name_id))

	for i = 1, self._page_count, 1 do
		MWSUpdateBanner:UpdateModsName(i)
		
		local content_panel = self._internal_content_panel:panel({
			x = (i == 1 and 0 or 1) * self._content_panel:w()
		})
		local image_panel = content_panel:panel({
			y = header_h,
			height = IMAGE_H
		})

		image_panel:bitmap({
			texture = MWSUpdateBanner.ppath[i]
		})
		content_panel:set_h(image_panel:bottom())

		max_h = math.max(max_h, image_panel:bottom())

		table.insert(self._contents, content_panel)
	end

	BoxGuiObject:new(self._internal_image_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	self._selected_box = BoxGuiObject:new(self._internal_image_panel, {
		sides = {
			2,
			2,
			2,
			2
		}
	})

	self._selected_box:set_visible(false)
	self._internal_content_panel:set_h(max_h)

	self._page_panel = self._content_panel:panel({
		h = 16,
		y = self._internal_content_panel:bottom() + PANEL_PADDING
	})
	self._page_buttons = {}

	for i = 1, self._page_count, 1 do
		local page_button = self._page_panel:bitmap({
			texture = "guis/textures/pd2/ad_spot"
		})

		page_button:set_center_x(i / (self._page_count + 1) * self._page_panel:w() / 2 + self._page_panel:w() / 4)
		page_button:set_center_y((self._page_panel:h() - page_button:h()) / 2)
		table.insert(self._page_buttons, page_button)
	end

	self._content_panel:set_h(self._page_panel:bottom())

	if managers.menu_component._player_profile_gui then
		local wx = self._content_panel:world_x()
		local wy = managers.menu_component._player_profile_gui._panel:world_y()
		wx, wy = managers.gui_data:convert_pos(ws, fullscreen_ws, wx, wy)

		self._content_panel:set_world_y(wy - header_h)
		self._content_panel:set_x(wx)
	else
		self._content_panel:set_bottom(self._panel:height() - PANEL_PADDING * 2)
	end

	self._bar = self._page_panel:bitmap({
		texture = "guis/textures/pd2/shared_lines",
		valign = "grow",
		halign = "grow",
		wrap_mode = "wrap",
		x = BAR_X,
		y = BAR_Y,
		w = BAR_W,
		h = BAR_H
	})

	self:set_bar_width(BAR_W, true)
	self._bar:set_top(self._page_buttons[1]:top() + BAR_Y)
	self._bar:set_left(self._page_buttons[1]:left() + BAR_X)

	self._select_rect = self._full_panel:bitmap({
		texture = "guis/textures/pd2/ad_blue2",
		layer = -2
	})

	self._select_rect:set_visible(false)
	self._select_rect:set_bottom(self._full_panel:height())
	self._select_rect:set_right(self._full_panel:width())

	self._queued_page = nil

	self:try_get_dummy()	

	for i = 1, 6 do
		local mws_id = MWSUpdateBanner:GetModsMWSID(i)
		tweak_data.gui.new_heists[i].url= "https://modworkshop.net/mydownloads.php?action=view_down&did="..mws_id
	end
end

Hooks:PostHook(NewHeistsGui, "_set_text", "MWSUpdateBanner_set_text", function(self)
	local mod_name = MWSUpdateBanner:GetModsName(self._current_page)
	self._text:set_text(mod_name)
	self:make_fine_text(self._text)
	self._text:set_right(self._internal_content_panel:w())
end)