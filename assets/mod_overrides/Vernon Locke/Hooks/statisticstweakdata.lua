local locke_player_statistics_table = StatisticsTweakData.statistics_table

function StatisticsTweakData:statistics_table(...)
	local _level_list, _job_list, _mask_list, _weapon_list, _melee_list, _grenade_list, enemy_list, armor_list, character_list, deployable_list = locke_player_statistics_table(self, ...)
	character_list[#character_list+1] = "locke_player"
	return _level_list, _job_list, _mask_list, _weapon_list, _melee_list, _grenade_list, enemy_list, armor_list, character_list, deployable_list
end