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

Hooks:PostHook(WorldDefinition, "make_unit", "F_"..Idstring("PostHook:WorldDefinition:make_unit:OverBurn"):key(), function(self, data, offset, ...)
	if not Global.game_settings or Global.game_settings.level_id ~= "red2" then
	
	else
		local old_name = tostring(data.name)
		if old_name == "units/payday2/pickups/gen_pku_money_multi/gen_pku_money_multi" or old_name == "units/world/props/bank/money_wrap/money_wrap_single_bundle" then
			if data.position and mvector3.distance(data.position, OverBurnMoneyAreaCenter) < OverBurnMoneyAreaRange then
				local s_unit = nil
				local _rotation = Rotation(math.random(-180, 180), 0, 0)
				s_unit = CoreUnit.safe_spawn_unit(Idstring("units/payday2/pickups/gen_pku_gold/gen_pku_gold"), data.position, _rotation)
				if s_unit then
					s_unit:interaction():set_active(true, true)
				end
			end
		end
	end
end)