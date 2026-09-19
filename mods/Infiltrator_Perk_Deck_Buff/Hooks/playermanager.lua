__old_upgrade_value112233 = __old_upgrade_value112233 or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local __ans = __old_upgrade_value112233(self, category, upgrade, ...)
	local player = managers.player:player_unit()
	if player and self:has_category_upgrade("player", "infiltrator_damage_dampener_bonus") and ((category == "temporary" and upgrade == "dmg_dampener_close_contact") or (category == "temporary" and upgrade == "dmg_dampener_outnumbered_strong")) then
		local __now_t = TimerManager:game():time()
		self.__infiltrator_damage_dampener_bonus_cd = self.__infiltrator_damage_dampener_bonus_cd or 0
		if self.__infiltrator_damage_dampener_bonus_cd < __now_t then		
			local __buff = self:upgrade_value("player", "infiltrator_damage_dampener_bonus")
			local __cd = self:upgrade_value("player", "infiltrator_damage_dampener_bonus_cd")
			self.__infiltrator_damage_dampener_bonus_cd = __now_t + __cd
			local heisters = World:find_units("sphere", player:position(), 400, World:make_slot_mask(2, 3, 4, 5, 16, 24))
			if type(heisters) == "table" and #heisters > 0 then
				for _, __unit in pairs(heisters) do
					if __unit ~= player then
						local __reduce = math.clamp(1 - __ans[1], 0.02, 0.98)
						__reduce = math.clamp(__reduce * __buff, 0.02, 0.98)
						__ans[1] = math.clamp(1 - __reduce, 0.02, 0.98)
						break
					end
				end
			end
		end
	end
	return __ans
end

function PlayerManager:__add_infiltrator_damage_dampener_bonus_cd(__var)
	local __now_t = TimerManager:game():time()
	__var = __var or 3
	self.__infiltrator_damage_dampener_bonus_cd = self.__infiltrator_damage_dampener_bonus_cd or 0
	self.__infiltrator_damage_dampener_bonus_cd = __now_t + __var
end
