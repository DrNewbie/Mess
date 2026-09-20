local ThisModPath = ModPath

local __Name = function(__id)
	return "RRR_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local IDS_UNIT = Idstring("unit")

local IDS_FAK = Idstring("units/pd2_dlc_old_hoxton/equipment/gen_equipment_first_aid_kit/gen_equipment_first_aid_kit_dummy")

local IDS_INTERACT_KEY = Idstring("units/world/props/apartment/apartment_key_dummy/apartment_key_dummy")

local all_key_units = {}

local remove_unit = function(this_unit)	
	if this_unit and alive(this_unit) then
		World:delete_unit(this_unit)
	end
	if this_unit and alive(this_unit) then
		this_unit:set_slot(0)
	end
end

local is_drop_fak = __Name(100)

Hooks:PreHook(MedicDamage, "init", __Name(990), function(self, ...)
	if math.random() <= 0.250 then
		self[is_drop_fak] = true
		self:set_pickup(nil)
	else
		self[is_drop_fak] = false
	end
end)

Hooks:PreHook(MedicDamage, "die", __Name(999), function(self, ...)
	if self[is_drop_fak] then
		local __key_unit = safe_spawn_unit(IDS_INTERACT_KEY, self._unit:position() + Vector3(0, 0, 50), Rotation())
		local __this_bag = safe_spawn_unit(IDS_FAK, self._unit:position() + Vector3(0, 0, 50), Rotation())
		__key_unit:interaction().__this_bag = __this_bag
		__key_unit:interaction()._tweak_data.text_id = "debug_equipment_first_aid_kit"
		__key_unit:interaction()._tweak_data.equipment_text_id = "debug_equipment_first_aid_kit"
		__key_unit:interaction()._tweak_data.special_equipment = nil
		__key_unit:interaction()._tweak_data.timer = 1
		__key_unit:interaction().interact = function(them, ...)
			if managers.player and managers.player:local_player() then
				managers.player:local_player():character_damage():band_aid_health()
			end
			them:set_active(false)
			DelayedCalls:Add(__Name(them._unit), 0.1, function()
				remove_unit(them.__this_bag)
				remove_unit(them._unit)
			end)
		end
		all_key_units[__key_unit:key()] = {
			__key_unit = __key_unit,
			__this_bag = __this_bag,
			__time = 10
		}
	else
	end
end)

pcall(function()
	DelayedCalls:Add(__Name(0), 1, function()
		managers.dyn_resource:load(IDS_UNIT, IDS_FAK, DynamicResourceManager.DYN_RESOURCES_PACKAGE)
		managers.dyn_resource:load(IDS_UNIT, IDS_INTERACT_KEY, DynamicResourceManager.DYN_RESOURCES_PACKAGE)
	end)
end)

Hooks:Add("GameSetupUpdate", __Name(1), function(__t, __dt)
	if type(all_key_units) == "table" then
		for __key, __data in pairs(all_key_units) do
			if type(__key) == "userdata" and type(__data) == "table" and type(__data.__time) == "number" then
				if __data.__time > 0 then
					all_key_units[__key].__time = all_key_units[__key].__time - __dt
				end
				if __data.__time <= 0 then
					remove_unit(__data.__this_bag)
					remove_unit(__data.__key_unit)
					all_key_units[__key] = nil
				end
			end
		end
	end
end)