function NewRaycastWeaponBase:__update_heat_material()
	local __is_done
	if type(self._parts) == "table" and self.__heat_material and self.__heat_material_parameter then
		local ids_heat_material = Idstring(self.__heat_material)
		local ids_heat_material_param = Idstring(self.__heat_material_parameter)
		for id, part in pairs(self._parts) do
			if part.unit then
				local materials = part.unit:get_objects_by_type(Idstring("material"))
				if type(materials) == "table" then
					for _, material in ipairs(materials) do
						if ids_heat_material == material:name() then
							local start_verheating_threshold = 0.15
							if start_verheating_threshold < self.__overheat_current then
								material:set_variable(ids_heat_material_param, (self.__overheat_current - start_verheating_threshold) * 1 / start_verheating_threshold)
							else
								material:set_variable(ids_heat_material_param, 0)
							end
							__is_done = true
						end
					end
				end
			end
		end
	end
	return __is_done
end

function NewRaycastWeaponBase:__weapon_heat_function_init()
	self.__overheat_current = 0
	self.__overheat_time = 3
	self.__overheat_speed = 0
	self.__overheated = false
	self.__heat_material = "blinn2"
	self.__heat_material_parameter = "intensity"
	self.__is_overheat_function = self:__update_heat_material()
end

function NewRaycastWeaponBase:__increase_heat(__var)
	self.__overheat_current = math.min(self.__overheat_current + __var, 8)
	self:__update_heat_material()
	return
end

function NewRaycastWeaponBase:__decrease_heat(__var)
	self.__overheat_current = math.max(self.__overheat_current - __var, 0)
	self:__update_heat_material()
	return
end

function NewRaycastWeaponBase:__get_overheat_current(__var)
	return self.__overheat_current
end