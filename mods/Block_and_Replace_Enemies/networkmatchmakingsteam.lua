local mod_ids = Idstring(ModPath):key()
local hook1 = "LockLobby_"..Idstring("set_attributes::"..mod_ids):key()
local hook2 = "LockLobby_"..Idstring("search_lobby::"..mod_ids):key()
local hook3 = "LockLobby_"..Idstring("load_user_filters::"..mod_ids):key()

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