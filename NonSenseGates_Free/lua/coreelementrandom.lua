core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

if not Global.game_settings or Global.game_settings.level_id ~= "branchbank" then
	return
end

if Network:is_client() then
	return
end

local _f_ElementRandom_on_executed = ElementRandom.on_executed

function ElementRandom:on_executed(instigator)
	local _id = tostring(self._id)
	if Global.game_settings then
		if Global.game_settings.level_id == "branchbank" then
			if _id == "104743" then
				if not self._values.enabled then
					return
				end
				self._unused_randoms = {}
				for i, element_data in ipairs(self._original_on_executed) do
					if tostring(element_data.id) == "104658" then
						if not self._values.ignore_disabled or self._values.ignore_disabled and self:get_mission_element(element_data.id):enabled() then
							table.insert(self._unused_randoms, i)
						end
					end
				end
				self._values.on_executed = {}
				table.insert(self._values.on_executed, self._original_on_executed[self:_get_random_elements()])
				ElementRandom.super.on_executed(self, instigator)
				return
			end
		end
	end
	return _f_ElementRandom_on_executed(self, instigator)
end