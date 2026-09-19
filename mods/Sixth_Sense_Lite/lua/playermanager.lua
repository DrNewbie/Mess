local mod_ids = Idstring("Sixth Sense Lite"):key()
local func1 = "F_"..Idstring("func1:"..mod_ids):key()
local func2 = "F_"..Idstring("func2:"..mod_ids):key()
local func3 = "F_"..Idstring("func3:"..mod_ids):key()

Hooks:PostHook(PlayerManager, "update", func1, function(self, t ,dt)
	if self:player_unit() and self:player_unit():movement() and type(self[func3]) == "table" and type(self[func3].area) == "number" and managers.groupai:state():whisper_mode() then
		if self[func3].dt then
			self[func3].dt = self[func3].dt - dt
			if self[func3].dt < 0 then
				self[func3].dt = nil
			end
		else
			self[func3].dt = 1.5
			local __sensed_targets = World:find_units_quick("sphere", self:player_unit():movement():m_pos(), tweak_data.player.omniscience.sense_radius * 0.5, managers.slot:get_mask("trip_mine_targets"))
			for _, unit in pairs(__sensed_targets) do
				if alive(unit) and not unit:base():char_tweak().is_escort then
					managers.game_play_central:auto_highlight_enemy(unit)
				end
			end
		end
	end
end)

Hooks:PostHook(PlayerManager, "init_finalize", func2, function(self)
	self[func3] = {
		area = 5,
		dt = nil
	}
end)