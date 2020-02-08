local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function IntimitateInteractionExt:pgt_interact(interacter)
	if CopDamage.is_civilian(self._unit:base()._tweak_table) then
		local state
		if self.tweak_data == 'hostage_move' then
			self._unit:base().pgt_is_being_moved = interacter
			self._unit:base().pgt_destination = nil
			state = true
		elseif self.tweak_data == 'hostage_stay' then
			self._unit:base().pgt_is_being_moved = nil
			self._unit:base().pgt_destination = nil
			state = false
		end
		if Network:is_server() then
			local brain = self._unit:brain()
			brain:on_pgt_state_changed(state)
			brain._logic_data.internal_data.check_surroundings_t = 0
			brain._logic_data.internal_data.rebellion_meter = 0
		end
	end
end

local pgt_original_intimitateinteractionext_interact = IntimitateInteractionExt.interact
function IntimitateInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end
	self:pgt_interact(player)
	pgt_original_intimitateinteractionext_interact(self, player)
end

local pgt_original_intimitateinteractionext_syncinteracted = IntimitateInteractionExt.sync_interacted
function IntimitateInteractionExt:sync_interacted(peer, player, status, ...)
	if (status == 'interrupted' or status == 2) and self.tweak_data ~= 'corpse_alarm_pager' then
		-- "interrupted" signal sent when a player dies, useless even dangerous for anything but pagers
		return
	end

	local unit = player or peer and peer:unit()
	self:pgt_interact(unit)

	pgt_original_intimitateinteractionext_syncinteracted(self, peer, player, status, ...)
end
