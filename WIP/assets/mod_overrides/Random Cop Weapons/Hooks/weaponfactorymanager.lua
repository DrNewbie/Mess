if Utils:IsInGameState() then
	WeaponFactoryManager.RandomWeaponMap = {}
end

WeaponFactoryManager.GeneralWeaponWeaponMap = {
	is_shotgun_pump = true,
	is_pistol = true,
	is_rifle = true,
	is_smg = true,
	is_lmg = true,
	is_shotgun_mag = true,
	is_revolver = true
}

function WeaponFactoryManager:RandomWeaponMapInit()
	self.RandomWeaponMap = {}
	for weapon_id, data in pairs(tweak_data.weapon) do
		if weapon_id:find("_crew") and data.hold and data.usage then
			local factory_id = self:get_factory_id_by_weapon_id(weapon_id:gsub("_crew", ""))
			if factory_id and tweak_data.weapon.factory[factory_id.."_npc"] then
				local usage = data.usage
				if self.GeneralWeaponWeaponMap[usage] then
					usage = "GeneralWeapon"
				end
				self.RandomWeaponMap[usage] = self.RandomWeaponMap[usage] or {}
				table.insert(self.RandomWeaponMap[usage], factory_id.."_npc")
				local factory_weapon = tweak_data.weapon.factory[factory_id]
				if factory_weapon then
					local ids_unit_name = Idstring(factory_weapon.unit)
					if not managers.dyn_resource:is_resource_ready(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
						managers.dyn_resource:load(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
					end
				end
				factory_weapon = tweak_data.weapon.factory[factory_id.."_npc"]
				if factory_weapon then
					local ids_unit_name = Idstring(factory_weapon.unit)
					if not managers.dyn_resource:is_resource_ready(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
						managers.dyn_resource:load(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
					end
				end
			end
		end
	end
end

function WeaponFactoryManager:GetFromRandomWeaponMap(usage)
	if not usage then
		return nil
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	if not self.RandomWeaponMap then
		self:RandomWeaponMapInit()
	end
	if self.GeneralWeaponWeaponMap[usage] then
		usage = "GeneralWeapon"
	end
	return self.RandomWeaponMap and self.RandomWeaponMap[usage] or nil
end

Hooks:PostHook(WeaponFactoryManager, "_read_factory_data", "Do_RandomWeaponMapInit", function(self)
	self:RandomWeaponMapInit()
end)