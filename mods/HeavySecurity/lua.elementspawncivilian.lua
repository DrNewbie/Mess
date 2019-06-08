core:import("CoreMissionScriptElement")
ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)

if not HeavySecurity or not HeavySecurity.settings or not HeavySecurity.settings.Level or not HeavySecurity.settings.Enable then
	return
end

Hooks:PostHook(ElementSpawnCivilian, "produce", "F_"..Idstring("Post.ElementSpawnCivilian.produce.HeavySecurity"):key(), function(self, params)
	if not Network:is_client() and managers.groupai:state():whisper_mode() and self._units and self._units[#self._units] then
		_cop = self._units[#self._units]
		if HeavySecurity.settings.AllCivilians and managers.enemy:is_civilian(_cop) then
			HeavySecurity:Spawn(_cop, self)
		end
	end
end)