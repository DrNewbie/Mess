local cmd_original_copmovement_load = CopMovement.load
function CopMovement:load(load_data)
	cmd_original_copmovement_load(self, load_data)

	if CopDamage.is_civilian(self._unit:base()._tweak_table) then
		if not self:cool() and self._unit:character_damage() and not self._unit:character_damage():dead() then
			if not self._unit:anim_data().tied then
				DelayedCalls:Add('CMD_civmark_' .. tostring(self._unit:id()), 0, function()
					managers.groupai:state():on_criminal_suspicion_progress(nil, self._unit, true)
				end)
			end
		end
	end
end
