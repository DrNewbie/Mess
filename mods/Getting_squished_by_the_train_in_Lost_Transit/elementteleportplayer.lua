core:import("CoreMissionScriptElement")
ElementTeleportPlayer = ElementTeleportPlayer or class(CoreMissionScriptElement.MissionScriptElement)

local id_offset = 152467 - 100217

if ElementTeleportPlayer then
	Hooks:PreHook(ElementTeleportPlayer, "on_executed", "TEST00000000000", function(self)
		if (self._id == 100217 + id_offset and self._editor_name == "point_teleport_player_001") or 
			(self._id == 100243 + id_offset and self._editor_name == "point_teleport_player_002") then
			self._values.enabled = false
		end
	end)
end