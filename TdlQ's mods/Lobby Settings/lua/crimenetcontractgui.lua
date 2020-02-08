local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ls_original_crimenetcontractgui_setdifficultyid = CrimeNetContractGui.set_difficulty_id
function CrimeNetContractGui:set_difficulty_id(difficulty_id)
	LobbySettings.settings.difficulty = difficulty_id
	LobbySettings:Save()
	ls_original_crimenetcontractgui_setdifficultyid(self, difficulty_id)
end

local ls_original_crimenetcontractgui_setonedown = CrimeNetContractGui.set_one_down
function CrimeNetContractGui:set_one_down(one_down)
	LobbySettings.settings.one_down = one_down
	LobbySettings:Save()
	ls_original_crimenetcontractgui_setonedown(self, one_down)
end
