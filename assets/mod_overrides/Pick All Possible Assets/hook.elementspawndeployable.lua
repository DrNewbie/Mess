core:import("CoreMissionScriptElement")

ElementSpawnDeployable = ElementSpawnDeployable or class(CoreMissionScriptElement.MissionScriptElement)

local UAA_SpawnDeployable = ElementSpawnDeployable.on_executed

UAA_Allow = UAA_Allow or {}

local UAA_Used = UAA_Used or {}

function ElementSpawnDeployable:on_executed(...)
	if not self._values.enabled then
		return
	end
	local _id = 'ID_'..self._id
	if UAA_Used[_id] then
		return
	end
	UAA_Used[_id] = true
	UAA_SpawnDeployable(self, ...)
	if true then
		local _runE = {}
		for _, script in pairs(managers.mission:scripts()) do
			for id, element in pairs(script:elements()) do
				if element:values().deployable_id and UAA_Allow[tostring(element:values().deployable_id)] then
					table.insert(_runE, element)
				end
			end
		end
		for _, element in pairs(_runE) do
			element:on_executed()
		end
	end
end
