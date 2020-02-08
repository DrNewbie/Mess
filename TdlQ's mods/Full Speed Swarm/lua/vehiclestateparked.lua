local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function VehicleStateParked:update(t, dt)
	if self._unit:vehicle():velocity():length() < 0.002 then
		return
	end
	self.super.update(self, t, dt)
end
