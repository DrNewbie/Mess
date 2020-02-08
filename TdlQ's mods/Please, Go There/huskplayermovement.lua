local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local _restart = _G.pgt_restart

local pgt_original_huskplayermovement_synccallcivilian = HuskPlayerMovement.sync_call_civilian
function HuskPlayerMovement:sync_call_civilian(civilian_unit, secondary)
	local civilian_base = civilian_unit:base()
	local owner = civilian_base.pgt_is_being_moved
	if owner then
		CivilianLogicSurrender.pgt_reset_rebellion(civilian_unit:brain()._logic_data)

		if self._unit == owner then
			if secondary then
				-- send
				local peer_id = managers.network:session():peer_by_unit(owner):id()
				local wp_position = managers.hud and managers.hud:gcw_get_custom_waypoint_by_peer(peer_id)
				if not wp_position then
					if Network:is_server() then
						civilian_unit:brain():on_hostage_move_interaction(nil, 'stay')
					end
					return
				end

				local old_dst = civilian_base.pgt_destination
				local same_dst = old_dst and mvector3.equal(wp_position, old_dst)
				if not same_dst then
					civilian_base.pgt_destination = mvector3.copy(wp_position)
					_restart(civilian_unit)
				end

			else
				-- call
				if civilian_base.pgt_destination then
					civilian_base.pgt_destination = nil
				end
				_restart(civilian_unit)
			end
		end

		return
	end

	pgt_original_huskplayermovement_synccallcivilian(self, civilian_unit, secondary)
end
