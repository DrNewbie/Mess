local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

-- ElementDeleteVehicle
ElementDeleteVehicle = ElementDeleteVehicle or class(ElementUnloadStatic)

function ElementDeleteVehicle:on_executed(...)
	ElementDeleteVehicle.super.on_executed(self, ...)
	managers.vehicle:on_simulation_started() -- yeah, just so I don't have to write that loop
end

-- ElementAINavSeg
ElementAINavSeg = ElementAINavSeg or class(CoreMissionScriptElement.MissionScriptElement)

function ElementAINavSeg:init(...)
	ElementAINavSeg.super.init(self, ...)
end

function ElementAINavSeg:client_on_executed(...)
	self:on_executed(...)
end

function ElementAINavSeg:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local segs = self._values.segment_ids
	for i = 1, #segs, 2 do
		managers.navigation:clbk_navfield(self._values.operation, { [segs[i]] = {segs[i + 1]} })
	end

	ElementAINavSeg.super.on_executed(self, instigator)
end

-- ElementChangeBodyProperty
ElementChangeBodyProperty = ElementChangeBodyProperty or class(CoreMissionScriptElement.MissionScriptElement)

function ElementChangeBodyProperty:init(...)
	ElementChangeBodyProperty.super.init(self, ...)
end

function ElementChangeBodyProperty:client_on_executed(...)
	self:on_executed(...)
end

function ElementChangeBodyProperty:_change(unit, params)
	if alive(unit) then
		local body = unit:body(params[2])
		if body then
			local property_writer = params[3]
			local value = params[4]
			if body[property_writer] then
				body[property_writer](body, value)
			else
				log('[ElementChangeBodyProperty] uh?... ' .. tostring(property_writer))
			end
		end
	end
end

function ElementChangeBodyProperty:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, thing in ipairs(self._values.things) do
		local unit = managers.worlddefinition:get_unit_on_load(thing[1], callback(self, self, '_change', thing[2], thing[3], thing[4]))
		if unit then
			self:_change(unit, thing)
		end
	end

	ElementChangeBodyProperty.super.on_executed(self, instigator)
end
