core:import("CoreMissionScriptElement")
ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

if Network:is_client() then
	return
end

function ElementSpawnEnemyDummy:produce(params)
	return
end