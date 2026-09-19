if Network:is_client() then
	return
end

if not Global.game_settings or Global.game_settings.level_id ~= "cane" then
	return
end

core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

function MissionScriptElement:_calc_base_delay()
	if self._id == 101660 or self._id == 100647 then
		return 1
	end
	if not self._values.base_delay_rand then
		return self._values.base_delay
	end
	return self._values.base_delay + math.rand(self._values.base_delay_rand)
end
	