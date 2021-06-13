local ThisModPath = ModPath
local ThisModSave = io.open(ThisModPath.."__record.json", "r")
local ThisModJson = {Times = 0, Hash = 'none'}
if ThisModSave then
	ThisModJson = json.decode(ThisModSave:read("*all"))
	ThisModSave:close()
	ThisModSave = nil
else
	ThisModSave = io.open(ThisModPath.."__record.json", "w+")
	if ThisModSave then
		ThisModJson.Times = 0
		ThisModJson.Hash = "none"
		ThisModSave:write(json.encode(ThisModJson))
		ThisModSave:close()
		ThisModSave = nil
	end
end

local ThisUnitLinkToWep = {}
local logger_unit = "units/mods/chl_prop_workshop_scorer/chl_prop_workshop_scorer"
local logger_unit_ids = Idstring(logger_unit)

local banner_unit = "units/mods/chl_prop_workshop_scorer/editable_text_short/editable_text_short"
local banner_unit_ids = Idstring(banner_unit)

local crashlog_path = Application:nice_path(os.getenv("LOCALAPPDATA")..'/PAYDAY 2/', true)..'crashlog.txt'

Hooks:Add("MenuManagerOnOpenMenu", "F_"..Idstring("Crash Counter::logger"):key(), function(self, menu)
	if menu == "menu_main" then
		DelayedCalls:Add("F_"..Idstring("DelayedCalls:Crash Counter::logger"):key(), 0.5, function()
			if io.file_is_readable(crashlog_path) then
				local __crash_log_text_ids = file.FileHash(crashlog_path)
				if __crash_log_text_ids ~= ThisModJson.Hash then
					if ThisModJson.Hash ~= "none" then
						ThisModJson.Times = ThisModJson.Times + 1
					else
						local __date_table = os.date("*t")
						local __hour, __minute, __second = __date_table.hour, __date_table.min, __date_table.sec
						local __year, __month, __day = __date_table.year, __date_table.month, __date_table.wday
						ThisModJson.Since = string.format("%d-%d-%d %d:%d:%d", __year, __month, __day, __hour, __minute, __second)
					end
					ThisModJson.Hash = __crash_log_text_ids
					ThisModSave = io.open(ThisModPath.."__record.json", "w+")
					if ThisModSave then
						ThisModSave:write(json.encode(ThisModJson))
						ThisModSave:close()
					end
				end
			end
			if ThisUnitLinkToWep.__logger_unit and alive(ThisUnitLinkToWep.__logger_unit) then
				World:delete_unit(ThisUnitLinkToWep.__logger_unit)
				ThisUnitLinkToWep.__logger_unit = nil
			end
			if ThisUnitLinkToWep.__banner_unit and alive(ThisUnitLinkToWep.__banner_unit) then
				World:delete_unit(ThisUnitLinkToWep.__banner_unit)
				ThisUnitLinkToWep.__banner_unit = nil
			end
			if DB:has("unit", logger_unit) then
				local __logger = World:spawn_unit(logger_unit_ids, Vector3(70, 200, 0), Rotation())
				if __logger then
					ThisUnitLinkToWep.__logger_unit = __logger
					if __logger.digital_gui and __logger:digital_gui() then
						__logger:digital_gui():number_set(math.min(ThisModJson.Times, 99999))
					end
				end
			end
			if DB:has("unit", banner_unit) then
				local __banner = World:spawn_unit(banner_unit_ids, Vector3(24, 150, 45), Rotation(0, 90, 0))
				if __banner then
					ThisUnitLinkToWep.__banner_unit = __banner
					if __banner.editable_gui and __banner:editable_gui() then
						__banner:editable_gui():set_text("CRASH COUNTER")
						__banner:editable_gui():set_font_size(0.87)
						__banner:editable_gui():set_font_color(Vector3(1, 1, 1))
						__banner:editable_gui():set_font("fonts/font_eroded")
						__banner:editable_gui():set_align("left")
						__banner:editable_gui():set_vertical("center")
						__banner:editable_gui():set_blend_mode("normal")
						__banner:editable_gui():set_render_template("diffuse_vc_decal")
						__banner:editable_gui():set_wrap(false)
						__banner:editable_gui():set_word_wrap(false)
						__banner:editable_gui():set_alpha(1)
						__banner:editable_gui():set_shape({0, 0, 1, 1})
					end
				end
			end
		end)
	end
end)

Hooks:PostHook(MenuSceneManager, "update", "F_"..Idstring("Crash Counter::RGB::update"):key(), function(self, t, dt)
	if type(ThisUnitLinkToWep) == "table" and ThisUnitLinkToWep.__banner_unit then
		local __banner = ThisUnitLinkToWep and alive(ThisUnitLinkToWep.__banner_unit) and ThisUnitLinkToWep.__banner_unit
		if __banner and __banner.editable_gui and __banner:editable_gui() then
			local __red = math.sin(135 * t) / 2 + 0.5
			local __green = math.sin(140 * t + 60) / 2 + 0.5
			local __blue = math.sin(145 * t + 120) / 2 + 0.5
			__banner:editable_gui():set_font_color(Vector3(__red, __green, __blue))
		end
	end
end)