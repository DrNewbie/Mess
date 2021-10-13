local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()
local __Dt1 = "F_"..Idstring("__Dt1::"..ThisModIds):key()
local Func1 = "F_"..Idstring("Func1::"..ThisModIds):key()
local Bool1 = "F_"..Idstring("Too Close To See::"..ThisModIds):key()
local Bool2 = "F_"..Idstring("Time To Reset Material::"..ThisModIds):key()
local Table1 = "F_"..Idstring("Packages List::"..ThisModIds):key()
local Table2 = "F_"..Idstring("Materials List::"..ThisModIds):key()

PlayerManager[Table1] = {
	"packages/bloody_ak5_body_test0000"
}

PlayerManager[Bool1] = 150 * 150 -- 1.5m

PlayerManager[Bool2] = 3

PlayerManager[Table2] = {
	[Idstring("units/payday2/weapons/wpn_fps_ass_ak5_pts/wpn_fps_ass_ak5_body_ak5"):key()] = Idstring("textures/memes/weapons/ak5/bloody/bloody_ak5_body_ak5"),
	[Idstring("units/payday2/weapons/wpn_fps_ass_ak5_pts/wpn_fps_ass_ak5_body_ak5_cc"):key()] = Idstring("textures/memes/weapons/ak5/bloody/bloody_ak5_body_ak5_cc")
}

PlayerManager[Func1] = PlayerManager[Func1] or function(__them, __unit, __key)
	local material_config_ids = Idstring("material_config")
	local match_material_config_ids = PlayerManager[Table2]
	local old_material_config_ids = __unit:material_config()
	local new_material_config_ids = match_material_config_ids[old_material_config_ids:key()] or nil
	if new_material_config_ids and DB:has(material_config_ids, new_material_config_ids) then
		__unit:set_material_config(new_material_config_ids, true, function ()
		
		end)
		__key = __key or __unit:id()
		__them[__Dt1] = __them[__Dt1] or {}
		__them[__Dt1][__key] = {
			unit = __unit,
			dt = PlayerManager[Bool2],
			old = old_material_config_ids
		}
	end	
end

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

Hooks:PostHook(PlayerManager, "on_killshot", Hook2, function(self, __killed_unit, __variant, __headshot, __weapon_id)
	local player_unit = self:player_unit()
	if not player_unit or not player_unit.inventory or not player_unit:inventory() then
	
	else
		local __weapon_melee = __weapon_id and tweak_data.blackmarket and tweak_data.blackmarket.melee_weapons and tweak_data.blackmarket.melee_weapons[__weapon_id] and true
		local __dist_sq = mvector3.distance_sq(player_unit:movement():m_pos(), __killed_unit:movement():m_pos())
		if __dist_sq <= self[Bool1] then
			if __weapon_melee then
				self[Func1](self, part.unit, __weapon_id)
			else
				for i_sel, selection_data in pairs(player_unit:inventory()._available_selections) do
					if selection_data.unit and alive(selection_data.unit) and selection_data.unit:base() then
						local weapon_base = selection_data.unit:base()
						for part_id, part in pairs(weapon_base._parts) do
							local part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(part_id, weapon_base._factory_id, weapon_base._blueprint)
							if part_data then
								self[Func1](self, part.unit)
							end
						end
					end
				end
			end
		end
	end
end)

for _, __LoadThisPackage in pairs(PlayerManager[Table1]) do
	if PackageManager:package_exists(__LoadThisPackage) then
		PackageManager:load(__LoadThisPackage)
	end
end