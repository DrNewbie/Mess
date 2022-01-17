_G.BoR_Enemy = _G.BoR_Enemy or {}
BoR_Enemy = BoR_Enemy or {}

local hook1 = BoR_Enemy:Name("set_attributes")
local hook2 = BoR_Enemy:Name("search_lobby")
local hook3 = BoR_Enemy:Name("load_user_filters")

NetworkMatchMakingSTEAM[hook1] = NetworkMatchMakingSTEAM[hook1] or NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	if settings.numbers[3] == 1 then
		settings.numbers[3] = 2
	end
	self[hook1](self, settings, ...)
end

NetworkMatchMakingSTEAM[hook2] = NetworkMatchMakingSTEAM[hook2] or NetworkMatchMakingSTEAM.search_lobby
function NetworkMatchMakingSTEAM:search_lobby(friends_only, ...)
	self[hook2](self, true, ...)
end

Hooks:PostHook(NetworkMatchMakingSTEAM, "load_user_filters", hook3, function()
	Global.game_settings.search_friends_only = true
end)