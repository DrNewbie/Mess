local DrillGetTheFckUp = BaseInteractionExt.interact

function BaseInteractionExt:interact(player, ...)
	if self:can_interact(player) then
		if type(self.tweak_data) == "string" and self.tweak_data:find("jammed") then
			managers.player:local_player():sound():say("f36x_any", true, true)
		end
	end
	return DrillGetTheFckUp(self, player, ...)
end