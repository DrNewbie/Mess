local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ls_original_menucrimenetcrimespreecontractinitiator_modifynode = MenuCrimeNetCrimeSpreeContractInitiator.modify_node
function MenuCrimeNetCrimeSpreeContractInitiator:modify_node(original_node, data)
	if not data.id and data.job_id == 'crime_spree' then
		data.id = 'crime_spree'
	end

	local node = ls_original_menucrimenetcrimespreecontractinitiator_modifynode(self, original_node, data)

	if Global.game_settings.single_player then
		LobbySettings:InsertBotLimiter(node)
	elseif data.smart_matchmaking then
		-- Nothing
	elseif data.id == 'crime_spree' then
		if node:item('lobby_reputation_permission'):visible() then
			LobbySettings:InsertInfamyLimiter(node)
			LobbySettings:InsertPlayerLimiter(node)
		end
		if node:item('toggle_ai'):visible() then
			LobbySettings:InsertBotLimiter(node)
		end
	end

	return node
end
