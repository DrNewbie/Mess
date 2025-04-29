local ThisModPath = tostring(ModPath)
local ThisModIds = Idstring(ThisModPath):key()

local ThisModFilesPath = ThisModPath.."/files/"

local __file = file
local __io = io

local __Name = function(__id)
	return "K_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

if _G[__Name(1)] then return end
_G[__Name(1)] = true

blt.xaudio.setup()

local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.pd2_tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size

local function HUDBGBox_create_ex(panel, config)
	local box_panel = panel
	local color = config and config.color
	local bg_color = config and config.bg_color or Color(1, 0, 0, 0)
	local blend_mode = config and config.blend_mode

	box_panel:rect({
		blend_mode = "normal",
		name = "bg",
		halign = "grow",
		alpha = 0.4,
		layer = -1,
		valign = "grow",
		color = bg_color
	})

	local left_top = box_panel:bitmap({
		texture = "guis/textures/pd2/hud_corner",
		name = "left_top",
		visible = true,
		layer = 0,
		y = 0,
		halign = "left",
		x = 0,
		valign = "top",
		color = color,
		blend_mode = blend_mode
	})
	local left_bottom = box_panel:bitmap({
		texture = "guis/textures/pd2/hud_corner",
		name = "left_bottom",
		visible = true,
		layer = 0,
		x = 0,
		y = 0,
		halign = "left",
		rotation = -90,
		valign = "bottom",
		color = color,
		blend_mode = blend_mode
	})

	left_bottom:set_bottom(box_panel:h())

	local right_top = box_panel:bitmap({
		texture = "guis/textures/pd2/hud_corner",
		name = "right_top",
		visible = true,
		layer = 0,
		x = 0,
		y = 0,
		halign = "right",
		rotation = 90,
		valign = "top",
		color = color,
		blend_mode = blend_mode
	})

	right_top:set_right(box_panel:w())

	local right_bottom = box_panel:bitmap({
		texture = "guis/textures/pd2/hud_corner",
		name = "right_bottom",
		visible = true,
		layer = 0,
		x = 0,
		y = 0,
		halign = "right",
		rotation = 180,
		valign = "bottom",
		color = color,
		blend_mode = blend_mode
	})

	right_bottom:set_right(box_panel:w())
	right_bottom:set_bottom(box_panel:h())

	return box_panel
end

HudBattleAnnouncersNotification = HudBattleAnnouncersNotification or class(ExtendedPanel)
HudBattleAnnouncersNotification.ICON_SIZE = 80
HudBattleAnnouncersNotification.BOX_MAX_W = 400
HudBattleAnnouncersNotification.default_queue = HudBattleAnnouncersNotification.default_queue or {}
HudBattleAnnouncersNotification.icon_list = HudBattleAnnouncersNotification.icon_list or {}

local ThisModData = __Name(302)
local __popup_position_x = __Name("battle_announcers_popup_position_x")
local __popup_position_y = __Name("battle_announcers_popup_position_y")

HudBattleAnnouncersNotification.__ply_ogg = function (__this_ogg, __main_volume)
	if type(__this_ogg) == "string" then
		__this_ogg = ThisModFilesPath.."/"..__this_ogg
		if __io.file_is_readable(__this_ogg) then
			local this_buffer = XAudio.Buffer:new(__this_ogg)
			local this_source = nil
			if managers.player and managers.player:local_player() then
				this_source = XAudio.UnitSource:new(XAudio.PLAYER, this_buffer)
			else
				this_source = XAudio.Source:new()
				this_source:set_buffer(this_buffer)
			end
			_G[ThisModData] = _G[ThisModData] or {}
			if type(__main_volume) == "string" and type(_G[ThisModData][__main_volume]) == "number" then
				this_source:set_volume(math.clamp(_G[ThisModData][__main_volume] / 100, 0, 100))
			else
				this_source:set_volume(1)
			end
			this_source:play()
			local __delay = this_buffer:get_length()
			return __delay + 2.666
		end
	end
	return 0
end

local box_speed = 2000

HudBattleAnnouncersNotification.__animate_open = function (panel, done_cb)
	local target_w = panel:w()
	panel:set_w(0)
	panel:set_visible(true)
	local speed = box_speed
	local TOTAL_T = target_w / speed
	local t = TOTAL_T
	while t > 0 do
		coroutine.yield()
		local dt = TimerManager:main():delta_time()
		t = t - dt
		panel:set_w((1 - t / TOTAL_T) * target_w)
	end
	panel:set_w(target_w)
	done_cb()
end

HudBattleAnnouncersNotification.__animate_close  = function (panel, done_cb)
	local speed = box_speed
	local cw = panel:w()
	local TOTAL_T = cw / speed
	local t = TOTAL_T
	while t > 0 do
		coroutine.yield()
		local dt = TimerManager:main():delta_time()
		t = t - dt
		panel:set_w(t / TOTAL_T * cw)
	end
	panel:set_w(0)
	done_cb()
end

HudBattleAnnouncersNotification.__wait_global = function (seconds)
	local t = 0
	while seconds > t do
		coroutine.yield()
		local dt = TimerManager:main():delta_time()
		t = t + dt
	end
end

function HudBattleAnnouncersNotification.load_config()
	--[[		
		__config = {
			version = <number>,
			<type> = {
				<sub_table_1>,
				<sub_table_2>,
				<sub_table_3>,
				...
			}
		}
	]]
	--[[
		sub_table = {
			chance = <number>, -- larger = more chance
			global_delay = <number>, -- second , default = 0 , used to delay entire the system
			type_delay = <number>, -- second , default = 30 , used to delay only this type

			title = "<string>",
			description = "<string>",
			sound = "<string>", -- path to .ogg
			icon = "<string>", -- path to .dds or .texture
			
			use_required_weapons = { -- this sub_table require using specify weapons.
				"<Weapon ID 1>", -- https://wiki.modworkshop.net/books/payday-2-mod-creation/page/weapons
				"<Weapon ID 2>",
				"<Weapon ID 3>"
				...
			}
			
			-- vvv OnHeistComplete Only vvv
			is_gameover_state = <boolean>, -- when lose
			is_victory_state = <boolean>, -- when win			
			-- ^^^ OnHeistComplete Only ^^^
		}
	]]
	--[[
		load all sub cfg into list
	]]
	HudBattleAnnouncersNotification.__config = {}
	if not __file.DirectoryExists(ThisModFilesPath) then
		return
	end
	local cfg_data = {}
	local __sub_folder = __file.GetDirectories(ThisModFilesPath)
	for _, folder_name in pairs(__sub_folder) do
		local full_path = ThisModFilesPath.."/"..folder_name
		local cfg_path = full_path.."/config.txt"
		if __io.file_is_readable(cfg_path) then
			local load_from_cfg = __io.load_as_json(cfg_path, "r")
			if type(load_from_cfg) == "table" then
				load_from_cfg.__main_volume = __Name(folder_name.."::main_volume")
				table.insert(cfg_data, load_from_cfg)
			end
		end
	end
	--[[
		data format
	]]
	HudBattleAnnouncersNotification.__type_data_ready = {}
	for __type, _ in pairs(Message) do
		HudBattleAnnouncersNotification.__type_data_ready[__type] = HudBattleAnnouncersNotification.__type_data_ready[__type] or {}
		for _, sub_data in pairs(cfg_data) do
			local sub_type_data = sub_data[__type]
			if type(sub_type_data) == "table" then
				for __key, __data in pairs(sub_type_data) do
					if type(__data) == "table" then
					
						__data.__main_volume = sub_data.__main_volume
						
						if type(__data.global_delay) ~= "number" then
							__data.global_delay = 0
						end
						if type(__data.type_delay) ~= "number" then
							__data.type_delay = 30
						end
						if type(__data.chance) ~= "number" then
							__data.chance = 1
						end
						if type(__data.title) ~= "string" then
							__data.title = ""
						end
						if type(__data.description) ~= "string" then
							__data.description = ""
						end
						if type(__data.sound) ~= "string" then
							__data.sound = ""
						end
						if type(__data.icon) ~= "string" then
							__data.icon = ""
						end
						if type(__data.use_required_weapons) == "table" then
							for _, __use_required_weapon_id in pairs(__data.use_required_weapons) do
								local use_weapon = __Name("use_weapon::"..tostring(__use_required_weapon_id))
								__data[use_weapon] = true
							end
							__data.use_required_weapons = nil
						end
						pcall(
							function ()
								if __io.file_is_readable(ThisModFilesPath.."/"..__data.icon) then
									BLTAssetManager:CreateEntry( 
										__Name(__data.icon), 
										"texture", 
										ThisModFilesPath..__data.icon, 
										nil 
									)
								end
								return
							end
						)
						for __insert = 1, __data.chance do
							table.insert(HudBattleAnnouncersNotification.__type_data_ready[__type], __data)
						end
					end
				end
			end
		end
	end
	return
end

function HudBattleAnnouncersNotification.queue(title, text, icon, __sound, __main_volume, queue)
	if Application:editor() then
		return
	end
	queue = queue or HudBattleAnnouncersNotification.default_queue
	table.insert(queue, {
		title,
		text,
		icon,
		__sound,
		__main_volume,
		queue
	})
	if #queue == 1 then
		return HudBattleAnnouncersNotification:new(unpack(queue[1]))
	end
	return
end

_G.HudBattleAnnouncersNotification.global_delay = 0

local function __basic_before_queue(__type)
	if type(HudBattleAnnouncersNotification.__type_data_ready) ~= "table" then
		return
	end
	if type(HudBattleAnnouncersNotification.__type_data_ready[__type]) ~= "table" then
		return
	end
	local __now_time = TimerManager:game():time()
	if _G.HudBattleAnnouncersNotification.global_delay > __now_time then
		return
	end
	_G.HudBattleAnnouncersNotification.type_delay = _G.HudBattleAnnouncersNotification.type_delay or {}
	_G.HudBattleAnnouncersNotification.type_delay[__type] = _G.HudBattleAnnouncersNotification.type_delay[__type] or 0
	if _G.HudBattleAnnouncersNotification.type_delay[__type] > __now_time then
		return
	end
	return true
end

function HudBattleAnnouncersNotification.queue_by_type(__type, __possible_data)
	if not __basic_before_queue(__type) then
		return
	end
	local __now_time = TimerManager:game():time()
	HudBattleAnnouncersNotification.__type_data_ready[__type] = HudBattleAnnouncersNotification.__type_data_ready[__type] or {}
	local __pick_data = __possible_data and table.random(__possible_data) or table.random(HudBattleAnnouncersNotification.__type_data_ready[__type])
	if type(__pick_data) == "table" then
		_G.HudBattleAnnouncersNotification.global_delay = __now_time + __pick_data.global_delay
		_G.HudBattleAnnouncersNotification.type_delay[__type] = __now_time + __pick_data.type_delay
		if __pick_data.is_empty then
			return
		end
		return HudBattleAnnouncersNotification.queue(
			__pick_data.title, 
			__pick_data.description, 
			__pick_data.icon, 
			__pick_data.sound,
			__pick_data.__main_volume
		)
	end
	return
end

function HudBattleAnnouncersNotification.queue_by_type_and_weapon(__type, __weapon_id)
	if not __basic_before_queue(__type) then
		return
	end
	HudBattleAnnouncersNotification.__type_data_ready[__type] = HudBattleAnnouncersNotification.__type_data_ready[__type] or {}
	local __possible_data = HudBattleAnnouncersNotification.__type_data_ready[__type]
	if type(__possible_data) == "table" then
		local __new_possible_data = {}
		local use_weapon = __Name("use_weapon::"..tostring(__weapon_id))
		for __id, __data in pairs(__possible_data) do
			if __data[use_weapon] then
				table.insert(__new_possible_data, __data)
			end
		end
		return HudBattleAnnouncersNotification.queue_by_type(__type, __new_possible_data)
	end
	return
end

function HudBattleAnnouncersNotification.queue_by_heist(__data_from_end)
	if type(__data_from_end) ~= "table" then
		return
	end
	local __possible_data = HudBattleAnnouncersNotification.__type_data_ready["OnHeistComplete"]
	if type(__possible_data) ~= "table" then
		return
	end
	if type(__data_from_end.job_id) ~= "string" or type(__data_from_end.level_id) ~= "string" then
		return
	end
	if not tweak_data.narrative.jobs[__data_from_end.job_id] or not tweak_data.levels[__data_from_end.level_id] then
		return
	end
	local __new_possible_data = {}
	for __id, __data in pairs(__possible_data) do
		if (__data.is_victory_state and __data_from_end.is_victory_state) or 
			(__data.is_gameover_state and __data_from_end.is_gameover_state) or 
			(__data.is_victory_state and __data.is_gameover_state) then 
			table.insert(__new_possible_data, __data)
		end
	end
	local __pick_data = __new_possible_data and table.random(__new_possible_data) or nil
	if type(__pick_data) == "table" then
		return HudBattleAnnouncersNotification.queue(
			__pick_data.title, 
			__pick_data.description, 
			__pick_data.icon, 
			__pick_data.sound,
			__pick_data.__main_volume
		)
	end
	return
end

function HudBattleAnnouncersNotification:init(title, text, icon, __sound, __main_volume, queue)
	if _G.IS_VR then
		HudBattleAnnouncersNotification.super.init(self, managers.hud:prompt_panel())
	else
		self._ws = managers.gui_data:create_fullscreen_workspace()
		HudBattleAnnouncersNotification.super.init(self, self._ws:panel())
	end
	self:set_layer(1000)
	self._queue = queue or {}
	self._top = ExtendedPanel:new(self)
	local title = self._top:fine_text({
		layer = 1,
		text = title or " ",
		font = small_font,
		font_size = small_font_size,
		color = Color.black
	})
	title:move(8, 0)
	self._top:set_size(title:right() + 8, title:h())
	self._top:bitmap({
		texture = "guis/textures/pd2/shared_tab_box",
		w = self._top:w(),
		h = self._top:h()
	})
	local box_size = (icon and self.ICON_SIZE * 2 or self.ICON_SIZE) + math.max(180, self._top:w())
	self._box = GrowPanel:new(self, {
		padding = 4,
		border = 4,
		w = box_size,
		y = self._top:bottom()
	})
	local placer = self._box:placer()
	local icon_texture, icon_texture_rect = __Name(icon), nil
	if icon_texture and DB:has("texture", icon_texture) then
		local icon_bitmap = self._box:fit_bitmap({
			texture = icon_texture,
			texture_rect = icon_texture_rect,
			w = self.ICON_SIZE,
			h = self.ICON_SIZE
		})
		placer:add_right(icon_bitmap)
		self._top:set_left(placer:current_right())
	end
	local description = self._box:fine_text({
		wrap = true,
		word_wrap = true,
		text = text,
		font = medium_font,
		font_size = medium_font_size,
		w = self.BOX_MAX_W - placer:current_left()
	})
	placer:add_right(description)
	local box_height = self._box:height()
	self._box:set_height(box_height)
	local total_w = self._box:right()
	self:set_w(total_w)
	self:set_h(self._box:bottom())
	self:set_center_x(self:parent():w() / 2)
	self:set_bottom(self:parent():h() * 5 / 7)
	self._box_bg = self:panel()
	self._box_bg:set_shape(self._box:shape())
	HUDBGBox_create_ex(self._box_bg)
	self._box:set_visible(false)
	self:set_top(self:parent():h() * 0.015)
	self:set_left(self:parent():w() * 0.015)
	
	_G[ThisModData] = _G[ThisModData] or {}
	if type(_G[ThisModData][__popup_position_x]) ~= "number" then
		_G[ThisModData][__popup_position_x] = self:center_x()
	else
		self:set_center_x(_G[ThisModData][__popup_position_x])
	end
	if type(_G[ThisModData][__popup_position_y]) ~= "number" then
		_G[ThisModData][__popup_position_y] = self:center_y()
	else
		self:set_center_y(_G[ThisModData][__popup_position_y])
	end
	
	local __delay = HudBattleAnnouncersNotification.__ply_ogg(__sound, __main_volume)
	if __delay > 0 then
		self._box_bg:animate(HudBattleAnnouncersNotification.__animate_open, function ()
			self._box:set_visible(true)
			HudBattleAnnouncersNotification.__wait_global(__delay)
			self._box:set_visible(false)
			self._box_bg:animate(HudBattleAnnouncersNotification.__animate_close, function ()
				self:close()
			end)
		end)
		return true
	else
		self:close()
	end
	return
end

function HudBattleAnnouncersNotification:close()
	self:remove_self()
	if self._ws and not _G.IS_VR then
		managers.gui_data:destroy_workspace(self._ws)
		self._ws = nil
	end
	table.remove(self._queue, 1)
	if #self._queue > 0 then
		HudBattleAnnouncersNotification:new(unpack(self._queue[1]))
	end
end