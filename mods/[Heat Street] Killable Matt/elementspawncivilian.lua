core:import("CoreMissionScriptElement")

ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "run" then
	return
end

local DedMatt_ElementSpawnCivilian_produce = ElementSpawnCivilian.produce

function ElementSpawnCivilian:produce(...)
	if not managers.groupai:state():is_AI_enabled() then
		return
	end
	local ans = DedMatt_ElementSpawnCivilian_produce(self, ...)
	if self._id == 102736 and self._editor_name == "matt001" then
		managers.groupai:state():DedMatt_RunMain(ans)
	end	
	return ans
end
