local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()
local __Dt1 = "F_"..Idstring("__Dt1::"..ThisModIds):key()

local ThisModReqPackage = "packages/bloody_ak5_body_test0000"
if PackageManager:package_exists(ThisModReqPackage) then
	PackageManager:load(ThisModReqPackage)
end

local material_config_ids = Idstring("material_config")

local match_material_config_ids = {
	[Idstring("units/payday2/weapons/wpn_fps_ass_ak5_pts/wpn_fps_ass_ak5_body_ak5"):key()] = Idstring("textures/memes/weapons/ak5/bloody/bloody_ak5_body_ak5"),
	[Idstring("units/payday2/weapons/wpn_fps_ass_ak5_pts/wpn_fps_ass_ak5_body_ak5_cc"):key()] = Idstring("textures/memes/weapons/ak5/bloody/bloody_ak5_body_ak5_cc")
}

Hooks:PostHook(PlayerManager, "update", Hook1, function(self, t, dt)
	if self[__Dt1] then
		for __key, __data in pairs(self[__Dt1]) do
			if not __data or not __data.unit or not alive(__data.unit) or not __data.dt or not __data.old then
				self[__Dt1][__key] = nil
			else
				if __data.dt and __data.dt > 0 then
					self[__Dt1][__key].dt = __data.dt - dt
				else
					self[__Dt1][__key].dt = nil
					self[__Dt1][__key].unit:set_material_config(__data.old, true)
				end
			end
		end
	end
end)

Hooks:PostHook(PlayerManager, "on_killshot", Hook2, function(self)
	local player_unit = self:player_unit()
	if not player_unit or not player_unit.inventory or not player_unit:inventory() then
	
	else
		for i_sel, selection_data in pairs(player_unit:inventory()._available_selections) do
			if selection_data.unit and alive(selection_data.unit) and selection_data.unit:base() then
				local weapon_base = selection_data.unit:base()
				for part_id, part in pairs(weapon_base._parts) do
					local part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(part_id, weapon_base._factory_id, weapon_base._blueprint)
					if part_data then
						local old_material_config_ids = part.unit:material_config()
						local new_material_config_ids = match_material_config_ids[old_material_config_ids:key()] or nil
						if new_material_config_ids and DB:has(material_config_ids, new_material_config_ids) then
							part.unit:set_material_config(new_material_config_ids, true, function ()
							
							end)
							self[__Dt1] = self[__Dt1] or {}
							self[__Dt1][part.unit:id()] = {
								unit = part.unit,
								dt = 3,
								old = old_material_config_ids
							}
						end						
					end
				end
			end
		end
	end
end)