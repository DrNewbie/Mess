local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_teamaibrain_onlongdisinteracted = TeamAIBrain.on_long_dis_interacted
function TeamAIBrain:on_long_dis_interacted(amount, other_unit, secondary)
	local peer_id = managers.network:session():peer_by_unit(other_unit):id()
	if not Keepers:IsModdedClient(peer_id) then
		Keepers:SendState(self._unit, Keepers:GetLuaNetworkingText(peer_id, self._unit, secondary and 2 or 1), secondary)
	end

	secondary = false
	return kpr_original_teamaibrain_onlongdisinteracted(self, amount, other_unit, secondary)
end
