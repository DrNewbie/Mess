local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ids_unit = Idstring('unit')
local ids_drill = Idstring('units/payday2/equipment/item_door_drill_small/item_door_drill_small')

local level_has_drill = {
	alex_2 = true,
	arm_cro = true,
	arm_fac = true,
	arm_for = true,
	arm_hcm = true,
	arm_par = true,
	arm_und = true,
	big = true,
	born = true,
	bph = true,
	branchbank = true,
	cane = true,
	chew = true,
	chill_combat = true,
	crojob2 = true,
	crojob3 = true,
	dark = true,
	dinner = true,
	election_day_1 = true,
	election_day_2 = true,
	election_day_3_skip1 = true,
	family = true,
	fish = true, -- stealth only
	firestarter_1 = true,
	firestarter_2 = true,
	firestarter_3 = true,
	four_stores = true,
	framing_frame_1 = true,
	framing_frame_3 = true,
	gallery = true,
	glace = true,
	help = true,
	hox_3 = true,
	jewelry_store = true,
	kenaz = true,
	kosugi = true,
	mad = true,
	mallcrasher = true,
	mex = true,
	mex_cooking = true,
	mia_1 = true,
	mia_2 = true,
	moon = true,
	mus = true,
	nail = true,
	nightclub = true,
	peta2 = true,
	pbr2 = true,
	red2 = true,
	roberts = true,
	shoutout_raid = true,
	spa = true,
	tag = true, -- stealth only
	ukrainian_job = true,
	vit = true,
	watchdogs_1 = true,
	welcome_to_the_jungle_1 = true,
	welcome_to_the_jungle_2 = true,
}	

function _G.mtga_level_has_drill(level_id)
	level_id = level_id:gsub('_night$', ''):gsub('_day$', '')
	return level_has_drill[level_id]
end

function _G.mtga_check_enable()
	if not mtga_users[1] then
		return false
	end

	if mtga_level_has_drill(Global.game_settings.level_id) then
		return true
	end

	for peer_id, state in pairs(mtga_users) do
		if state == false then
			return false
		end
	end

	return PackageManager:has(ids_unit, ids_drill)
end

function BaseNetworkSession:mtga_send_to_peers_synched(messageType, type_index, enabled, tweak_data_id, ...)
	for peer_id, peer in pairs(self._peers) do
		peer:send_queued_sync(messageType, type_index, enabled, mtga_users[peer_id] and tweak_data_id or 'drill', ...)
	end
end

Hooks:Add('NetworkReceivedData', 'NetworkReceivedData_MTGA', function(sender, messageType, data)
	if messageType == 'MTGA_drill' then
		local u_id = tonumber(data)
		for ukey, record in pairs(managers.groupai:state()._police) do
			local unit = record.unit
			if alive(unit) and unit:id() == u_id then
				mtga_start_drilling(unit:interaction())
				break
			end
		end

	elseif messageType == 'MTGA?' then
		mtga_users[sender] = true
		mtga_is_enabled = mtga_check_enable()
		LuaNetworking:SendToPeer(sender, 'MTGA!', '')

	elseif messageType == 'MTGA!' then
		mtga_users[sender] = true
		mtga_is_enabled = mtga_check_enable()
	end
end)

Hooks:Add('BaseNetworkSessionOnLoadComplete', 'BaseNetworkSessionOnLoadComplete_MTGA', function(local_peer, id)
	mtga_users[id] = true
	mtga_is_enabled = mtga_check_enable()
	LuaNetworking:SendToPeers('MTGA?', '')
end)

Hooks:Add('NetworkManagerOnPeerAdded', 'NetworkManagerOnPeerAdded_MTGA', function(peer, peer_id)
	mtga_users[peer_id] = false
	mtga_is_enabled = mtga_check_enable()
end)

Hooks:Add('BaseNetworkSessionOnPeerRemoved', 'BaseNetworkSessionOnPeerRemoved_MTGA', function(peer, peer_id, reason)
	mtga_users[peer_id] = nil
	mtga_is_enabled = mtga_check_enable()
end)
