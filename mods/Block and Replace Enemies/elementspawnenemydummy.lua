core:import("CoreMissionScriptElement")

_G.BoR_Enemy = _G.BoR_Enemy or {}
BoR_Enemy = BoR_Enemy or {}

local func1 = BoR_Enemy:Name("ElementSpawnEnemyDummy:produce")
local func2 = BoR_Enemy:Name("old:unit_name")

ElementSpawnEnemyDummy[func1] = ElementSpawnEnemyDummy[func1] or ElementSpawnEnemyDummy.produce

function ElementSpawnEnemyDummy:produce(params, ...)
	local unit_name = nil
	local which_one
	if params and params.name then
		unit_name = params.name
		which_one = true
	else
		unit_name = self:value("enemy") or self._enemy_name
		which_one = false
	end
	if unit_name then
		--[[
			Save unit name for next time
		]]
		self[func2] = self[func2] or unit_name
		unit_name = self[func2]
		--[[
			Run BoR_E
		]]
		local unit_type = BoR_Enemy:Get_EnemyType(unit_name)
		if type(unit_type) == "number" and unit_type > 0 and unit_type < 999 then
			local BoR_type = BoR_Enemy:Get_Value("value::"..unit_type) or 1
			--log("unit_type: " .. tostring(unit_type) .. "\t" .. "BoR_type: " .. tostring(BoR_type))
			if BoR_type == 1 then
				--Default, do nothing
			elseif BoR_type >= 2 and BoR_type <= 11 then
				local r_unit = table.random({
					Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				})
				if BoR_type ~= 2 then
					--Replace to special
					if BoR_type == 11 then
						--Random
						BoR_type = math.random(3, 9)
					elseif BoR_type == 10 then
						--Bulldozer+
						BoR_type = table.random({3, 3, 3, 8, 9})
					end
					local r_list = BoR_Enemy:Get_TypeEnemy(BoR_type)
					if type(r_list) == "table" and table.size(r_list) > 0 then
						r_unit = r_list[table.random_key(r_list)]
					end
				end
				if r_unit then
					if params and params.name then
						params.name = r_unit
					end
					if self:value("enemy") then
						self._values["enemy"] = r_unit
					end
					if self._enemy_name then
						self._enemy_name = r_unit
					end
				end
			end
		end
	end
	return self[func1](self, params, ...)
end