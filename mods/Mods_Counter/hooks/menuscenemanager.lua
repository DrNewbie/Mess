local ThisModPath = ModPath
local ThisModReqPackage = "packages/mod_crash_counter"
local ThisUnitLinkToWep = {}
local logger_unit = "units/mods/chl_prop_workshop_scorer/chl_prop_workshop_scorer"
local logger_unit_ids = Idstring(logger_unit)
local banner_unit = "units/mods/chl_prop_workshop_scorer/editable_text_short/editable_text_short"
local banner_unit_ids = Idstring(banner_unit)

local __file = file

function MenuSceneManager:ModsCounterLLLOptChanged()
	if type(ThisUnitLinkToWep) == "table" then
		if ThisUnitLinkToWep.__title and alive(ThisUnitLinkToWep.__title) then
			ThisUnitLinkToWep.__title:set_position(Vector3(
				ModsCounterLLL.Options:GetValue("__title_pos_x"),
				ModsCounterLLL.Options:GetValue("__title_pos_y"),
				ModsCounterLLL.Options:GetValue("__title_pos_z")
			))
			ThisUnitLinkToWep.__title:set_rotation(Rotation(
				ModsCounterLLL.Options:GetValue("__title_rot_x"),
				ModsCounterLLL.Options:GetValue("__title_rot_y"),
				ModsCounterLLL.Options:GetValue("__title_rot_z")
			))
		end
		if ThisUnitLinkToWep.__counter and alive(ThisUnitLinkToWep.__counter) then
			ThisUnitLinkToWep.__counter:set_position(Vector3(
				ModsCounterLLL.Options:GetValue("__counter_pos_x"),
				ModsCounterLLL.Options:GetValue("__counter_pos_y"),
				ModsCounterLLL.Options:GetValue("__counter_pos_z")
			))
			ThisUnitLinkToWep.__counter:set_rotation(Rotation(
				ModsCounterLLL.Options:GetValue("__counter_rot_x"),
				ModsCounterLLL.Options:GetValue("__counter_rot_y"),
				ModsCounterLLL.Options:GetValue("__counter_rot_z")
			))
		end
	end
	return
end

local function IsThisModRunInMainMenu()
	if PackageManager:loaded(ThisModReqPackage) and managers.menu and managers.menu:active_menu() and managers.menu:active_menu().logic:selected_node() then
		local __menu_name = managers.menu:active_menu().logic:selected_node():parameters().name
		if tostring(__menu_name) ~= "main" then
			--__DelayToSpawnModsCounter = false
		else
			return true
		end
	end
	return false
end

local function ThisModSpawnCounter()
	if not IsThisModRunInMainMenu() then
		return
	end
	local __counter = World:spawn_unit(logger_unit_ids, Vector3(70, 200, 0), Rotation())
	if __counter then
		ThisUnitLinkToWep.__counter = __counter
		if __counter.digital_gui and __counter:digital_gui() then
			local __mods, __mod_overrides, __maps = {}, {}, {}
			if __file.DirectoryExists("mods/") then
				__mods = __file.GetDirectories("mods/")
			end
			if __file.DirectoryExists("assets/mod_overrides/") then
				__mod_overrides = __file.GetDirectories("assets/mod_overrides/")
			end
			if __file.DirectoryExists("Maps/") then
				__maps = __file.GetDirectories("Maps/")
			end
			local __offset = 0
			local __bypass = {
				"mods/base/",
				"mods/saves/",
				"mods/logs/"
			}
			for _, __dir in pairs(__bypass) do
				if __file.DirectoryExists(__dir) then
					__offset = __offset + 1
				end
			end
			local __modsamount = #(__mods) + #(__mod_overrides) + #(__maps) - __offset
			__counter:digital_gui():number_set(math.min(__modsamount, 99999))
		end
	end
	return
end

local function ThisModSpawnBanner()
	if not IsThisModRunInMainMenu() then
		return
	end
	local __title = World:spawn_unit(banner_unit_ids, Vector3(-38, 150, 45), Rotation(0, 90, 0))
	if __title then
		ThisUnitLinkToWep.__title = __title
		if __title.editable_gui and __title:editable_gui() then
			__title:editable_gui():set_text("MODS COUNTER")
			__title:editable_gui():set_font_size(0.87)
			__title:editable_gui():set_font_color(Vector3(1, 1, 1))
			__title:editable_gui():set_font("fonts/font_eroded")
			__title:editable_gui():set_align("center")
			__title:editable_gui():set_vertical("center")
			__title:editable_gui():set_blend_mode("normal")
			__title:editable_gui():set_render_template("diffuse_vc_decal")
			__title:editable_gui():set_wrap(false)
			__title:editable_gui():set_word_wrap(false)
			__title:editable_gui():set_alpha(1)
			__title:editable_gui():set_shape({0, 0, 1, 1})
		end
	end
	return
end

local function pre_unload()
	if type(ThisUnitLinkToWep) == "table" then
		local __del_unit
		if ThisUnitLinkToWep.__title and alive(ThisUnitLinkToWep.__title) then
			__del_unit = ThisUnitLinkToWep.__title
			ThisUnitLinkToWep.__title = nil
			World:delete_unit(__del_unit)
		end
		if ThisUnitLinkToWep.__counter and alive(ThisUnitLinkToWep.__counter) then
			__del_unit = ThisUnitLinkToWep.__counter
			ThisUnitLinkToWep.__counter = nil
			World:delete_unit(__del_unit)
		end
	end
	return
end

Hooks:PreHook(MenuSceneManager, "pre_unload", "F_"..Idstring("Mods Counter::RGB::pre_unload"):key(), function(self)
	pcall(pre_unload)
end)

local function update(t)
	if type(ThisUnitLinkToWep) == "table" and ThisUnitLinkToWep.__title then
		local __banner = ThisUnitLinkToWep and alive(ThisUnitLinkToWep.__title) and ThisUnitLinkToWep.__title
		if __banner and __banner.editable_gui and __banner:editable_gui() then
			local __red = math.sin(135 * t) / 2 + 0.5
			local __green = math.sin(140 * t + 60) / 2 + 0.5
			local __blue = math.sin(145 * t + 120) / 2 + 0.5
			__banner:editable_gui():set_font_color(Vector3(__red, __green, __blue))
		end
	end
	if IsThisModRunInMainMenu() and not __DelayToSpawnModsCounter and math.round(t) % 5 == 0 and t > 5 then
		if managers.dyn_resource and DB:has("unit", logger_unit) and DB:has("unit", banner_unit) then
			__DelayToSpawnModsCounter = true
			if ThisUnitLinkToWep.__counter and alive(ThisUnitLinkToWep.__counter) then
				World:delete_unit(ThisUnitLinkToWep.__counter)
				ThisUnitLinkToWep.__counter = nil
			end
			if ThisUnitLinkToWep.__title and alive(ThisUnitLinkToWep.__title) then
				World:delete_unit(ThisUnitLinkToWep.__title)
				ThisUnitLinkToWep.__title = nil
			end
			pcall(ThisModSpawnCounter)
			pcall(ThisModSpawnBanner)
			if ModsCounterLLL and type(ModsCounterLLL.OptChanged) == "function" then
				ModsCounterLLL:OptChanged()
			end
		end
	end
	return
end

Hooks:PostHook(MenuSceneManager, "update", "F_"..Idstring("Mods Counter::RGB::update"):key(), function(self, t, ...)
	pcall(update, t)
end)

if PackageManager:package_exists(ThisModReqPackage) then
	PackageManager:load(ThisModReqPackage)
end	