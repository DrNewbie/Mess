local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local capp_original_groupaistatebase_fillcriminalteamwithai = GroupAIStateBase.fill_criminal_team_with_AI
function GroupAIStateBase:fill_criminal_team_with_AI(...)
	capp_original_groupaistatebase_fillcriminalteamwithai(self, ...)
	CrewAbilityPiedPiper:hud_show_cable_ties()
end
