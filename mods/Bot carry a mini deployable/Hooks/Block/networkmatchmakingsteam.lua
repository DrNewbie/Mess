local AABlock_set_attributes = NetworkMatchMakingSTEAM.set_attributes
function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
	if settings.numbers[3] == 1 then
		settings.numbers[3] = 2
	end
	AABlock_set_attributes(self, settings, ...)
end

local AABlock_search_lobby = NetworkMatchMakingSTEAM.search_lobby
function NetworkMatchMakingSTEAM:search_lobby(friends_only, ...)
	AABlock_search_lobby(self, true, ...)
end

function NetworkMatchMakingSTEAM:search_friends_only()
	return true
end

Hooks:PostHook(NetworkMatchMakingSTEAM, "load_user_filters", 'AA_load_user_filters', function()
	Global.game_settings.search_friends_only = true
end)