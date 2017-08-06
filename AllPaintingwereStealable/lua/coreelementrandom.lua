core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

local _f_ElementRandom_on_executed = ElementRandom.on_executed

function ElementRandom:on_executed(instigator)
	local _id = tostring(self._id)
	if Global.game_settings then
		if Global.game_settings.level_id == "gallery" then
			if _id == "100515" then
				if not self._values.enabled then
					return
				end
				self._unused_randoms = {}
				for i, element_data in ipairs(self._original_on_executed) do
					if not self._values.ignore_disabled or self._values.ignore_disabled and self:get_mission_element(element_data.id):enabled() then
						table.insert(self._unused_randoms, i)
					end
				end
				self._values.on_executed = {}
				local amount = 46
				for i = 1, math.min(amount, #self._original_on_executed) do
					table.insert(self._values.on_executed, self._original_on_executed[self:_get_random_elements()])
				end
				ElementRandom.super.on_executed(self, instigator)
				return
			end
		end
	end
	return _f_ElementRandom_on_executed(self, instigator)
end

