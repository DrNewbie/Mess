local pusg_vec
function PlayerMovement:on_SPOOCed(enemy_unit)
	if managers.player:has_category_upgrade("player", "counter_strike_spooc") and self._current_state.in_melee and self._current_state:in_melee() then
		self._current_state:discharge_melee()
		return "countered"
	end
	if self._unit:character_damage()._god_mode or self._unit:character_damage():get_mission_blocker("invulnerable") then
		return
	end
	if self._current_state_name == "standard" or self._current_state_name == "carry" or self._current_state_name == "bleed_out" or self._current_state_name == "tased" or self._current_state_name == "bipod" then
		local state = "incapacitated"
		state = managers.modifiers:modify_value("PlayerMovement:OnSpooked", state)
		managers.achievment:award(tweak_data.achievement.finally.award)
		local pusg_vec = self:m_pos() - enemy_unit:position()
		mvector3.normalize(pusg_vec)
		pusg_vec = pusg_vec + Vector3(0, 0, 2)
		mvector3.multiply(pusg_vec, 8000)
		self:push(pusg_vec)
		DelayedCalls:Add(Idstring('on_SPOOCed_Into_Sky_'..tostring(self._unit)):key(), 1, function()
			managers.player:set_player_state(state or "incapacitated")
		end)
		return true
	end
end