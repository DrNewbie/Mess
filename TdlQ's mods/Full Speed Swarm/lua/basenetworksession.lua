local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local max_players = tweak_data.max_players
function BaseNetworkSession:amount_of_alive_players()
	local count = 0

	local peers_all = self._peers_all
	for i = 1, max_players do
		local peer = peers_all[i]
		if peer and alive(peer:unit()) then
			count = count + 1
		end
	end

	return count
end

function BaseNetworkSession:peer_by_ip(ip)
	local peers_all = self._peers_all
	for i = 1, max_players do
		local peer = peers_all[i]
		if peer and peer:ip() == ip then
			return peer
		end
	end
end

function BaseNetworkSession:peer_by_user_id(user_id)
	local peers_all = self._peers_all
	for i = 1, max_players do
		local peer = peers_all[i]
		if peer and peer:user_id() == user_id then
			return peer
		end
	end
end

local fs_original_basenetworksession_checksendoutfit = BaseNetworkSession.check_send_outfit
function BaseNetworkSession:check_send_outfit(peer)
	if game_state_machine:current_state():name() == 'menu_main' then
		-- update it once AFTER all changes are done, or it spams peers with non definitive changes
		DelayedCalls:Add('DelayedModFSS_checksendoutfit', 0, function()
			fs_original_basenetworksession_checksendoutfit(self, peer)
		end)
	else
		fs_original_basenetworksession_checksendoutfit(self, peer)
	end
end

local fs_original_basenetworksession_getnextspawnpoint = BaseNetworkSession.get_next_spawn_point
function BaseNetworkSession:get_next_spawn_point()
	local result = fs_original_basenetworksession_getnextspawnpoint(self)

	if FullSpeedSwarm.tmp_spawn_one_teamAI then
		local spawn_pos = result.pos_rot[1]
		for _, element in ipairs(managers.mission._scripts.default._element_groups.ElementAreaTrigger or {}) do
			local values = element._values
			if values.instigator == 'criminals' and values.depth <= 100 and values.width <= 100 then
				if not values.enabled and values.trigger_on == 'on_enter' then
					if element:is_inside(spawn_pos) then
						values.enabled = true
						values.trigger_times = 1
						element:add_callback()
						break
					end
				end
			end
		end
	end

	return result
end
