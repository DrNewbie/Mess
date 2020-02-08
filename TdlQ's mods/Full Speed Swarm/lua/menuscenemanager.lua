local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_menuscenemanager_setlobbycharacteroutfit = MenuSceneManager.set_lobby_character_out_fit
function MenuSceneManager:set_lobby_character_out_fit(i, outfit_string, rank)
	DelayedCalls:Add('DelayedModFSS_setlobbycharacteroutfit_' .. tostring(i), 0.1, function()
		if managers.network:session() then
			fs_original_menuscenemanager_setlobbycharacteroutfit(self, i, outfit_string, rank)
		end
	end)
end
