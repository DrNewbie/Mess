core:import("CoreMissionScriptElement")

ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

local STOPMEDICFROMSPAWNPRODUCE = ElementSpawnEnemyDummy.produce

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
		local exChange = {
			[Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			[Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"):key()] = Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"),
			[Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"):key()] = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"),
			[Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"):key()] = Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
			
			[Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
			[Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"):key()] = Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"),
			[Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"):key()] = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"),
			[Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"):key()] = Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"),
			
			[Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"):key()] = Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
			[Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic"):key()] = Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2")
		}
		if exChange[unit_name:key()] then
			if which_one then
				params.name = exChange[unit_name:key()]
			else
				if self:value("enemy") then
					self._values["enemy"] = exChange[unit_name:key()]
				elseif self._enemy_name then
					self._enemy_name = exChange[unit_name:key()]
				end
			end
		end
	end
	return STOPMEDICFROMSPAWNPRODUCE(self, params, ...)
end