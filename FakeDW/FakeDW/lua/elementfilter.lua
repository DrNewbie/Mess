core:import("CoreMissionScriptElement")
ElementFilter = ElementFilter or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id then
	return
end

if Network:is_client() then
	return
end

function ElementFilter:_check_difficulty()
	local diff = "overkill_290"
	if self._values.difficulty_easy and diff == "easy" then
		return true
	end
	if self._values.difficulty_normal and diff == "normal" then
		return true
	end
	if self._values.difficulty_hard and diff == "hard" then
		return true
	end
	if self._values.difficulty_overkill and diff == "overkill" then
		return true
	end
	if self._values.difficulty_overkill_145 and diff == "overkill_145" then
		return true
	end
	local is_difficulty_overkill_290 = self._values.difficulty_overkill_290 == nil and self._values.difficulty_overkill_145 or self._values.difficulty_overkill_290
	if is_difficulty_overkill_290 and diff == "overkill_290" then
		return true
	end
	return false
end