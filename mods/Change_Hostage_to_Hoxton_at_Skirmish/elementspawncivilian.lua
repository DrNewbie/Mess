core:import("CoreMissionScriptElement")
core:import("CoreClass")

if not ElementSpawnCivilian then return end

if not PackageManager:loaded("packages/narr_hox_1") then
	PackageManager:load("packages/narr_hox_1")
end

Hooks:PreHook(ElementSpawnCivilian, "produce", Idstring("Change Hostage to Hoxton at Skirmish"):key(), function(self)
	if managers and managers.skirmish and managers.skirmish:is_skirmish() then
		self._enemy_name = Idstring("units/payday2/characters/npc_old_hoxton_prisonsuit_1/npc_old_hoxton_prisonsuit_1")
	end
end)