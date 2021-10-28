local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook0 = "F_"..Idstring("EnemyManager:on_enemy_died:"..ThisModIds):key()

Hooks:PostHook(EnemyManager, "on_enemy_died", Hook0, function(self, dead_unit)
	if (not Network or Network:is_server()) and managers.mutators:is_mutator_active(MutatorBirthday) and dead_unit:base():has_tag("special") then
		local birthday_mutator = managers.mutators:get_mutator(MutatorBirthday)
		birthday_mutator:on_special_killed(dead_unit)
	end
end)