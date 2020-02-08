local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function NetworkMatchMakingSTEAM:ls_check_lobby_health()
	if not self:is_server_joinable() then
		return
	end

	if not self.lobby_handler then
		return
	end

	if not self.lobby_handler:get_server_details() then
		log('[Lobby Settings] Lobby seems to be inaccessible')
		managers.network.matchmake:ls_create_lobby(MenuCallbackHandler:get_matchmake_attributes())
	end

	DelayedCalls:Add('DelayedMod_ls_checklobbyhealth', 30, function()
		self:ls_check_lobby_health()
	end)
end

local ls_original_networkmatchmakingsteam_setserverjoinable = NetworkMatchMakingSTEAM.set_server_joinable
function NetworkMatchMakingSTEAM:set_server_joinable(state)
	if state then
		state = managers.network:session():amount_of_players() < Global.game_settings.max_players
	end

	ls_original_networkmatchmakingsteam_setserverjoinable(self, state)

	if state then
		self:ls_check_lobby_health()
	end
end

function NetworkMatchMakingSTEAM:ls_recreate_lobby(delay)
	if Network:is_server() then
		DelayedCalls:Add('DelayedMod_ls_ondisconnected', delay or 15, function()
			managers.network.matchmake:ls_create_lobby(MenuCallbackHandler:get_matchmake_attributes())
		end)
	end
end

function NetworkMatchMakingSTEAM:ls_create_lobby(settings)
	local function f(result, handler)
		if result == 'success' then
			log('[Lobby Settings] Success!')
			self.lobby_handler = handler
			self:set_attributes(settings)
			self.lobby_handler:publish_server_details()
			self.lobby_handler:set_joinable(self._server_joinable)
			self.lobby_handler:setup_callbacks(NetworkMatchMakingSTEAM._on_memberstatus_change, NetworkMatchMakingSTEAM._on_data_update, NetworkMatchMakingSTEAM._on_chat_message)
		else
			managers.network.matchmake:ls_recreate_lobby()
		end
	end
	log('[Lobby Settings] Attempting to recreate lobby...')
	return Steam:create_lobby(f, NetworkMatchMakingSTEAM.OPEN_SLOTS, 'invisible')
end
