local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Network:is_client() then
	return
end

local mkp_original_carryinteractionext_interact = CarryInteractionExt.interact
function CarryInteractionExt:interact(player)
	local is_bot = alive(player) and player:base() and player:base()._tweak_table
	if not is_bot then
		return mkp_original_carryinteractionext_interact(self, player)
	end

	if not player:movement():carrying_bag() then
		CarryInteractionExt.super.super.interact(self, player)

		managers.network:session():send_to_peers_synched_except(1, 'sync_interacted', self._unit, self._unit:id(), self.tweak_data, 1)
		self:sync_interacted(nil, player)

		local carry_data = self._unit:carry_data()
		local unit_name = tweak_data.carry[carry_data:carry_id()].unit or 'units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag'
		local unit = World:spawn_unit(Idstring(unit_name), self:interact_position(), Rotation())

		managers.network:session():send_to_peers_synched('sync_carry_data', unit, carry_data._carry_id, 1, carry_data._dye_initiated, carry_data._has_dye_pack, carry_data._dye_value_multiplier, self:interact_position(), Vector3(), 0, nil, 0)

		managers.player:sync_carry_data(unit, carry_data._carry_id, 1, carry_data._dye_initiated, carry_data._has_dye_pack, carry_data._dye_value_multiplier, self:interact_position(), Vector3(), 0, nil, 0)

		unit:carry_data():link_to(player, false)
		managers.mission:call_global_event('on_picked_up_carry', self._unit)
	end

	return true
end
