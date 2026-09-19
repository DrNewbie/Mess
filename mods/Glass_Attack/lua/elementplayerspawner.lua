core:import("CoreMissionScriptElement")
ElementPlayerSpawner = ElementPlayerSpawner or class(CoreMissionScriptElement.MissionScriptElement)

function ElementPlayerSpawner:on_executed(instigator)
	local _id = tostring(self._id)
	if not self._values.enabled then
		return
	end
	if _id == "102635" then
		self._values.position = Vector3(1430, -775, 3050)
	end
	if _id == "102636" then
		self._values.position = Vector3(1430, 5900, 3050)
	end
	if _id == "102641" then
		self._values.position = Vector3(-8180, 5910, 3050)
	end
	if _id == "102642" then
		self._values.position = Vector3(-8180, -840, 3050)
	end
	managers.player:set_player_state(self._values.state or managers.player:default_player_state())
	managers.groupai:state():on_player_spawn_state_set(self._values.state or managers.player:default_player_state())
	managers.network:register_spawn_point(self._id, {
		position = self._values.position,
		rotation = self._values.rotation
	})
	ElementPlayerSpawner.super.on_executed(self, self._unit or instigator)
end