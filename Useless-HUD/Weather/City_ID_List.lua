_G.UselessHUD = _G.UselessHUD or {}

local _possible = {
	"1cecafd93c572ef21fc91f715ad690b6",
	"62e34c66bff387ad9d39c9d6e04a6751",
	"0da05c72cfdcb23a89f5a3de08cf02f7",
	"60f25109290a26074ec3078e9610a9fa",
	"c3d1b35e5161dbb625bcc75ec97bdac8",
}

UselessHUD.API = {
	Weather = "http://api.openweathermap.org/data/2.5/weather?appid=".. _possible[math.random(#_possible)] ..""
}

_possible = {}

local _level_index = tweak_data.levels._level_index or {}

UselessHUD.Level2CityID = {}

for _, _lv in pairs(_level_index) do
	UselessHUD.Level2CityID[_lv] = 4140963 -- Default is 'Washington, D. C., US'
end

UselessHUD.Level2CityID["jolly"] = 5368361 -- Aftershock, Los Angeles

UselessHUD.Level2CityID["mad"] = 2013465 -- Boiling Point, Verkhoyansk, I know OVK didn't say it was there

_level_index = {}