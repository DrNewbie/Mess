function PlayerManager:__EE_Armor_Conis()
	return 100
end

function PlayerManager:__EE_Armor_Possible_Amount()
	return {
		[1] = 100,
		[2] = 75,
		[3] = 25
	}
end

function PlayerManager:__EE_Armor_Bonus_List()
	return {
		[1] = 50, --+Recovery Rate
		[2] = 50, --+More Armor
		[3] = 30, --+Addon Dodge
		[4] = 30, --+More Stamina
		[5] = 5, --+SP: Thorns
		[6] = 5 --+SP: Protection
	}
end

function PlayerManager:__EE_Armor_Bonus_Type_List()
	return {
		[1] = "recovery_rate",
		[2] = "more_armor",
		[3] = "add_dodge",
		[4] = "add_stamina",
		[5] = "sp_thorns",
		[6] = "sp_protection"
	}
end

function PlayerManager:__EE_Armor_Bonus_Value(ee_i, lv)
	return self:__EE_Armor_Bonus_Value_List(lv)[ee_i]
end

function PlayerManager:__EE_Armor_Allow_Armor_List()
	return {
		--["level_1"] = true,
		--["level_2"] = true,
		--["level_3"] = true,
		--["level_4"] = true,
		--["level_5"] = true,
		--["level_6"] = true,
		["level_7"] = true
	}
end