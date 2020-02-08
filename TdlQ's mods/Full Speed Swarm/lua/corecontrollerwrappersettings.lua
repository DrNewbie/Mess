local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module("CoreControllerWrapperSettings")

local fs_original_controllerwrapperaxis_setmultiplier = ControllerWrapperAxis.set_multiplier
function ControllerWrapperAxis:set_multiplier(...)
	fs_original_controllerwrapperaxis_setmultiplier(self, ...)

	if mvector3.equal(self._multiplier, self.ONE_VECTOR) then
		self.fs_multiplier_x = nil
		self.fs_multiplier_y = nil
		self.fs_multiplier_z = nil
	else
		self.fs_multiplier_x = mvector3.x(self._multiplier)
		self.fs_multiplier_y = mvector3.y(self._multiplier)
		self.fs_multiplier_z = mvector3.z(self._multiplier)
	end
end

function ControllerWrapperAxis:fs_get_multiplier()
	return self.fs_multiplier_x, self.fs_multiplier_y, self.fs_multiplier_z
end

local fs_original_controllerwrapperaxis_setinversion = ControllerWrapperAxis.set_inversion
function ControllerWrapperAxis:set_inversion(...)
	fs_original_controllerwrapperaxis_setinversion(self, ...)

	if mvector3.equal(self._inversion, self.ONE_VECTOR) then
		self.fs_inversion_x = nil
		self.fs_inversion_y = nil
		self.fs_inversion_z = nil
	else
		self.fs_inversion_x = mvector3.x(self._inversion)
		self.fs_inversion_y = mvector3.y(self._inversion)
		self.fs_inversion_z = mvector3.z(self._inversion)
	end
end

function ControllerWrapperAxis:fs_get_inversion()
	return self.fs_inversion_x, self.fs_inversion_y, self.fs_inversion_z
end

function ControllerWrapperSettings:get_ref_engine_ids()
	local result = {}
	local cmap = self:get_connection_map()
	local i = 0
	for _, name in ipairs(self:get_connection_list()) do
		local zcmap = cmap[name]
		if zcmap._input_name_list and not zcmap._btn_connections and not zcmap._debug then
			result[i] = name
			i = i + 1
		end
	end
	return result
end
