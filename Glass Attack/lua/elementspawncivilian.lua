core:import("CoreMissionScriptElement")
ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)

if Network:is_client() then
	return
end

function ElementSpawnCivilian:produce(params)
	return
end