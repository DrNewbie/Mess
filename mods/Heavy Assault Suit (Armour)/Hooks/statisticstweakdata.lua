local old_statistics_table = StatisticsTweakData.statistics_table
function StatisticsTweakData:statistics_table(...)
	local __A1, __A2, __A3, __A4, __A5, __A6, __A7, __armor_list, __A8, __A9, __A10, __A11, __A12, __A13, __A14, __A15, __A16, __A17, __A18, __A19, __A20 = old_statistics_table(self, ...)
	__armor_list[9] = "level_9"
	return __A1, __A2, __A3, __A4, __A5, __A6, __A7, __armor_list, __A8, __A9, __A10, __A11, __A12, __A13, __A14, __A15, __A16, __A17, __A18, __A19, __A20
end