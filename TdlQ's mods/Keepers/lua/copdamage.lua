local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kpr_original_copdamage_ondamagereceived = CopDamage._on_damage_received
function CopDamage:_on_damage_received(damage_info)
	kpr_original_copdamage_ondamagereceived(self, damage_info)

	local owner_id = self._unit:base().kpr_minion_owner_peer_id
	if owner_id then
		local rd = Keepers.radial_health[self._unit:id()]
		if alive(rd) then
			rd:set_color(Color(1, self._health_ratio, 1, 1))
		end
	end
end
