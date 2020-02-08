local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

LobbySettings.original_MAX_NR_TEAM_AI = CriminalsManager.MAX_NR_TEAM_AI
if Global.game_settings then
	CriminalsManager.MAX_NR_TEAM_AI = Global.game_settings.max_bots
end
