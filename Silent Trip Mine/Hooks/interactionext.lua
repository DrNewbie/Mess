_G.SilentTripMine = _G.SilentTripMine or {}

function BaseInteractionExt:_has_required_deployable()
	if SilentTripMine:Check_Is_Silent() then
		self._tweak_data.required_deployable = "trip_mine_silent"
	end
	if self._tweak_data.required_deployable then
		return managers.player:has_deployable_left(self._tweak_data.required_deployable, self._tweak_data.slot or 1)
	end
	return true
end

function UseInteractionExt:interact(player)
	if not self:can_interact(player) then
		return
	end
	if SilentTripMine:Check_Is_Silent() then
		self._tweak_data.required_deployable = "trip_mine_silent"
	end
	UseInteractionExt.super.interact(self, player)
	if self._tweak_data.equipment_consume then
		managers.player:remove_special(self._tweak_data.special_equipment)
		if self._tweak_data.special_equipment == "planks" and Global.level_data.level_id == "secret_stash" then
			UseInteractionExt._saviour_count = (UseInteractionExt._saviour_count or 0) + 1
		end
	end
	if self._tweak_data.deployable_consume then
		managers.player:remove_equipment(self._tweak_data.required_deployable)
	end
	if self._tweak_data.sound_event then
		player:sound():play(self._tweak_data.sound_event)
	end
	self:remove_interact()
	if self._unit:damage() then
		self._unit:damage():run_sequence_simple("interact", {unit = player})
	end
	managers.network:session():send_to_peers_synched("sync_interacted", self._unit, -2, self.tweak_data, 1)
	if self._global_event then
		managers.mission:call_global_event(self._global_event, player)
	end
	self:set_active(false)
	return true
end