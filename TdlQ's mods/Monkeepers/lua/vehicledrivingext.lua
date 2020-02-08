local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Monkeepers.disabled then
	return
end

if Network:is_server() then
	local mkp_original_vehicledrivingext_syncstorelootinvehicle = VehicleDrivingExt.sync_store_loot_in_vehicle
	function VehicleDrivingExt:sync_store_loot_in_vehicle(unit, ...)
		local carry_data = unit:carry_data()

		mkp_original_vehicledrivingext_syncstorelootinvehicle(self, unit, ...)

		if carry_data and carry_data.mkp_callback then
			carry_data.mkp_callback(self, self._unit:position())
			carry_data.mkp_callback = nil
		end
	end
end
