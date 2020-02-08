local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ls_original_crewmanagementgui_init = CrewManagementGui.init
function CrewManagementGui:init(...)
	CriminalsManager.MAX_NR_TEAM_AI = LobbySettings.original_MAX_NR_TEAM_AI
	ls_original_crewmanagementgui_init(self, ...)
	CriminalsManager.MAX_NR_TEAM_AI = Global.game_settings.max_bots
end

local ls_original_crewmanagementgui_creatememberloadoutmap = CrewManagementGui._create_member_loadout_map
function CrewManagementGui:_create_member_loadout_map(...)
	CriminalsManager.MAX_NR_TEAM_AI = LobbySettings.original_MAX_NR_TEAM_AI
	local result = ls_original_crewmanagementgui_creatememberloadoutmap(self, ...)
	CriminalsManager.MAX_NR_TEAM_AI = Global.game_settings.max_bots
	return result
end
