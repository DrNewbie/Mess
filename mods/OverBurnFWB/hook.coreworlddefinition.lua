core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
WorldDefinition = WorldDefinition or class()

if Network and Network:is_client() then
	return
end

local OverBurn_WorldDefinition_make_unit = WorldDefinition.make_unit

local OverBurnMoneyAreaCenter = Vector3(7726, 1274, -300)
local OverBurnMoneyAreaRange = 1000

local is_editor = Application:editor()

function WorldDefinition:make_unit(data, offset, ...)
	if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	
	else
		local old_name = tostring(data.name)
		if old_name == "units/payday2/pickups/gen_pku_money_multi/gen_pku_money_multi" or old_name == "units/world/props/bank/money_wrap/money_wrap_single_bundle" then
			data.name = "units/payday2/pickups/gen_pku_gold/gen_pku_gold"
			if data.position and mvector3.distance(data.position, OverBurnMoneyAreaCenter) < OverBurnMoneyAreaRange then
				if old_name == "units/world/props/bank/money_wrap/money_wrap_single_bundle" then
					local s_unit = nil
					if MassUnitManager:can_spawn_unit(Idstring(data.name)) and not is_editor then
						s_unit = MassUnitManager:spawn_unit(Idstring(data.name), data.position + offset, data.rotation)
					else
						s_unit = CoreUnit.safe_spawn_unit(data.name, data.position, data.rotation)
					end
					if s_unit and s_unit.interaction and s_unit:interaction() then
						s_unit:interaction():set_active(true, true)
					end
					data.name = old_name
				end
			end
		end
	end
	return OverBurn_WorldDefinition_make_unit(self, data, offset, ...)
end