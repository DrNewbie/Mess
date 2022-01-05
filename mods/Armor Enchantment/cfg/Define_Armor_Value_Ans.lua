function PlayerManager:__EE_Armor_Bonus_Value_List(lv)
	local recovery_rate = function(__lv)
		return math.random(1, 15)
	end
	local more_armor = function(__lv)
		return math.random(1, 15)
	end
	local add_dodge = function(__lv)
		return math.random(1, 15)
	end
	local add_stamina = function(__lv)
		return math.random(1, 15)
	end
	return {
		[1] = recovery_rate(lv),
		[2] = more_armor(lv),
		[3] = add_dodge(lv),
		[4] = add_stamina(lv)
	}
end