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
	local add_movement_speed = function(__lv)
		return math.random(1, 15)
	end
	local add_carry_movement_speed = function(__lv)
		return math.random(30, 60)
	end
	local sp_thorns = function(__lv)
		return table.random({
			50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
			100, 100, 100, 100, 100,
			200
		})
	end
	local sp_protection = function(__lv)
		return table.random({
			11, 11, 11, 11, 11, 11, 11, 11, 11,
			33, 33, 33
		})
	end
	local sp_shockproof = function(__lv)
		return 1
	end
	local sp_impulse_fields = function(__lv)
		return 1
	end
	return {
		[1] = recovery_rate(lv),
		[2] = more_armor(lv),
		[3] = add_dodge(lv),
		[4] = add_stamina(lv),
		[5] = sp_thorns(lv),
		[6] = sp_protection(lv),
		[7] = sp_shockproof(lv),
		[8] = add_movement_speed(lv),
		[9] = add_carry_movement_speed(lv),
		[10] = sp_impulse_fields(lv)
	}
end