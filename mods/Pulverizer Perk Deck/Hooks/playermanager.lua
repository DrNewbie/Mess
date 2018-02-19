local pulverizer_run_and_punch = PlayerManager.mod_movement_penalty

function PlayerManager:mod_movement_penalty(...)
	local Ans = pulverizer_run_and_punch(self, ...)
	if self:current_state() == "standard" and self:has_category_upgrade("player", "passive_pulverizer_run_and_punch") then
		if self:player_unit() and self:player_unit():movement() and self:player_unit():movement()._current_state then
			if self:player_unit():movement()._current_state:_is_meleeing() then
				Ans = Ans * self:upgrade_value("player", "passive_pulverizer_run_and_punch", 1)
			end
		end
	end
	return Ans
end

local pulverizer_upgrade_value = PlayerManager.upgrade_value
function PlayerManager:upgrade_value(category, id, ...)
	local Ans = pulverizer_upgrade_value(self, category, id, ...)
	if category == "player" and id == "extra_ammo_multiplier" then
		Ans = Ans * self:upgrade_value("player", "passive_pulverizer_loss_ammo", 1)
	end
	return Ans
end