local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Monkeepers.disabled or Network:is_client() then
	return
end

local mvec3_dis = mvector3.distance

local mkp_original_carryinteractionext_collisioncallback = CarryInteractionExt._collision_callback
function CarryInteractionExt:_collision_callback(...)
	local need_register_collision

	local carry_data = self._unit:carry_data()
	local mkp_throw_t = carry_data.mkp_throw_t
	carry_data.mkp_throw_t = nil
	if carry_data.mkp_callback and not carry_data:is_linked_to_unit() then
		if carry_data.mkp_spawn_position and mvec3_dis(self._unit:position(), carry_data.mkp_spawn_position) < 60 then
			need_register_collision = true
		else
			carry_data.mkp_callback()
		end
	end

	mkp_original_carryinteractionext_collisioncallback(self, ...)

	if need_register_collision then
		if carry_data:can_explode() and not carry_data:explode_sequence_started() then
		else
			carry_data.mkp_throw_t = mkp_throw_t
			self:register_collision_callbacks()
		end
	end
end

local mkp_original_carryinteractionext_syncinteracted = CarryInteractionExt.sync_interacted
function CarryInteractionExt:sync_interacted(peer, player, status, skip_alive_check)
	if not self._remove_on_interact then
		local peer_id
		if alive(player) then
			peer_id = 1
		elseif peer then
			peer_id = peer:id()
		end
		if peer_id then
			Monkeepers.last_carry_pickup_pos[peer_id] = nil
		end
	end

	mkp_original_carryinteractionext_syncinteracted(self, peer, player, status, skip_alive_check)
end
