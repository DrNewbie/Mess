_G.UselessHUD = _G.UselessHUD or {}
UselessHUD.Text = UselessHUD.Text or {}
Uselesshud_Weather = Uselesshud_Weather or class()
function Uselesshud_Weather:init(hud)
    self._full_hud = hud
    self._uselesshud_weather_panel = self._full_hud:panel({
		visible = false,
        name = "uselesshud_weather_panel",
        layer = 100,
        valign = "center", 
        halign = "center",
    })
    self._uselesshud_weather_text = self._uselesshud_weather_panel:text({
		visible = false,
        name = "uselesshud_weather_text",
        vertical = "bottom",
        align = "center",
        text = "0",
        font_size = 24,
        layer = 100,
        color = Color.white,
        font = "fonts/font_large_mf"
    })   
    self._uselesshud_weather_panel:rect({
		visible = false,
        name = "uselesshud_weather_bg",
        halign = "grow",
        valign = "grow",
        layer = 0,
        color = Color.black
    })     
    local x,y,w,h = self._uselesshud_weather_text:text_rect()
    self._uselesshud_weather_panel:set_size(w + 6, h + 4)
    self._uselesshud_weather_text:set_size(w, h)
    self._uselesshud_weather_panel:set_center(self._full_hud:center_x(), self._full_hud:center_y() - 250)
end

function Uselesshud_Weather:GetData(data_used)
	local _url = ""
	local _resresh = 1800
	local _lv = Global.game_settings.level_id
	local _city = 4140963
	if UselessHUD.settings.Weather ~= 1 then
		return
	end
	if UselessHUD.Level2CityID and UselessHUD.Level2CityID[_lv] > 0 then
		_city = UselessHUD.Level2CityID[_lv]
	end
	if UselessHUD.settings.Weather_Specify_Bool == 1 and UselessHUD.settings.Weather_Specify_ID then
		_city = tonumber(UselessHUD.settings.Weather_Specify_ID)
	end
	if UselessHUD.settings.Weather_Local_Bool == 1 then
		if data_used and data_used.lat and data_used.lon then
			_url = UselessHUD.API.Weather .. "&lat=".. data_used.lat .."&lon=".. data_used.lon ..""			
		else
			dohttpreq("http://ip-api.com/json", function(data)
				if data and json then			
					local _data = json.decode(data) or {}
					if _data and _data.lat and _data.lon then
						self:GetData({lat = _data.lat, lon = _data.lon})
					end
				end
			end)
			return
		end
	else
		_url = UselessHUD.API.Weather .. "&id=" .. _city
	end
	dohttpreq(_url, function(data)
		if data and json then			
			local _data = json.decode(data) or {}
			if _data then
				if _data.name then
					UselessHUD.Text.Weather = {}
					local _txt = ""
					table.insert(UselessHUD.Text.Weather, "[ Weather App ]\n")
					table.insert(UselessHUD.Text.Weather, "- ".. _data.name .." -\n")
					table.insert(UselessHUD.Text.Weather, "".. _data.weather[1].main .."\n(".. _data.weather[1].description ..")\n")
					local _var = math.floor(_data.main.temp)
					_var = _var - 273.15
					_var = math.floor(_var)
					table.insert(UselessHUD.Text.Weather, "Temp: " .. _var .. " (Celsius)\n")				
					_var = math.floor(_data.main.pressure)
					table.insert(UselessHUD.Text.Weather, "Pressure: " .. _var .. " (hpa)\n")				
					_var = math.floor(_data.main.humidity)
					table.insert(UselessHUD.Text.Weather, "Humidity: " .. _var .. "% \n")
					self:SetVisible(true)
					for _, v in pairs(UselessHUD.Text.Weather or {}) do
						_txt = _txt .. "" .. v
					end
					self:SetData({text = _txt})
				else
					dofile("mods/Useless-HUD/Weather/City_ID_List.lua")
					_resresh = 5
				end
			else
				dofile("mods/Useless-HUD/Weather/City_ID_List.lua")
				_resresh = 5
			end
		end
	end)
	DelayedCalls:Add("DelayedCalls_Uselesshud_Weather_Update", _resresh, function()
		if UselessHUD.settings.Weather == 1 then
			self:GetData()
		end
	end)
end


function Uselesshud_Weather:SetVisible(data)
	self._uselesshud_weather_panel:set_visible(data)
	self._uselesshud_weather_text:set_visible(data)
end

function Uselesshud_Weather:SetData(data)
	self._uselesshud_weather_text:set_text(tostring(data.text))
	local x, y, w, h = self._uselesshud_weather_text:text_rect()
	self._uselesshud_weather_panel:set_size(w + 6,h + 4)
	self._uselesshud_weather_text:set_size(w,h)
	self._uselesshud_weather_panel:set_center(self._full_hud:center_x()*2 - 100, self._full_hud:center_y())    
	self._uselesshud_weather_panel:stop()
end