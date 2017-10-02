Hooks:Add("LocalizationManagerPostInit", "TimeSpeed_loc", function(...)
	LocalizationManager:add_localized_strings({
		["menu_TimeSpeed_Multiplier_name"] = "Time Speed",
		["menu_TimeSpeed_Multiplier_desc"] = " ",
		["TimeSpeed_Multiplier_1"] = "0.5",
		["TimeSpeed_Multiplier_2"] = "1",
		["TimeSpeed_Multiplier_3"] = "2",
		["TimeSpeed_Multiplier_4"] = "4",
		["TimeSpeed_Multiplier_5"] = "8"	
	})
end)

_G.TimeSpeed = _G.TimeSpeed or {}
TimeSpeed._ModPath = TimeSpeed._ModPath or ModPath
TimeSpeed._SavePath = TimeSpeed._SavePath or SavePath .. "TimeSpeed.txt"
TimeSpeed.Settings = TimeSpeed.Settings or {}

function TimeSpeed:Save()
	local file = io.open(self._SavePath, "w+")
	if file then
		file:write(json.encode(self.Settings))
		file:close()
	end
end

function TimeSpeed:Load()
	local file = io.open(self._SavePath, "r")
	if file then
		for k, v in pairs(json.decode(file:read("*all")) or {}) do
			self.Settings[k] = v
		end
		file:close()
	else
		self.Settings = {
			speedmultiplier = 3,
			speedmultiplier_list = {
				0.5,
				1,
				2,
				4,
				8
			}
		}
		self:Save()
	end
end

function TimeSpeed:Apply(Toggle)
	Toggle = Toggle or 0
	local m_timespeed = self.Settings.speedmultiplier_list[self.Settings.speedmultiplier] or 1
	if Toggle == -1 or Toggle == -2 then
		m_timespeed = 1.0
	elseif Toggle == 1 then
		m_timespeed = self.Settings.speedmultiplier_list[self.Settings.speedmultiplier]
	end
	SoundDevice:set_rtpc("game_speed", m_timespeed)
	for k, v in pairs({"player", "game", "game_animation"}) do
		TimerManager:timer(Idstring(v)):set_multiplier(m_timespeed)
	end
	if managers.hud then
		managers.hud:show_hint({
			text = ("%.1fx Speed"):format(m_timespeed), time = 1
		})
	end
end
	
function TimeSpeed:ForcedApply()
	self.Toggle = tostring(self.Toggle) == "-1" and 1 or -1
	self:Apply(self.Toggle)
end

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_TimeSpeed", function(...)

	TimeSpeed:Load()
	
	MenuCallbackHandler.TimeSpeed_Multiplier_menu_callback = function(this, item)
		TimeSpeed.Settings.speedmultiplier = tonumber(item:value()) or 2
		TimeSpeed:Save()
	end
	
	MenuCallbackHandler.TimeSpeed_Multiplier_Apply_callback = function(...)
		TimeSpeed:Apply()
	end
	
	if not Utils or not Utils:IsInGameState() then
		TimeSpeed:Apply(-2)
	end

	MenuHelper:LoadFromJsonFile(TimeSpeed._ModPath .. "Menu.json", TimeSpeed, TimeSpeed.Settings)
end)