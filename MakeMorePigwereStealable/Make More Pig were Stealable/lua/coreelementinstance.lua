core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")
ElementInstanceInput = ElementInstanceInput or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "dinner" then
	return
end

local _f_ElementInstanceInputEvent_on_executed = ElementInstanceInputEvent.on_executed

local _more_pig_do_once = false

function ElementInstanceInputEvent:on_executed(instigator)
	if not _more_pig_do_once then
		local _id_specify = {
			["id_101295"] = true,
			["id_103580"] = true,
			["id_101296"] = true,
			["id_103593"] = true,
			["id_102968"] = true,
			["id_103594"] = true,
			["id_103595"] = true,
			["id_103069"] = true,
			["id_103439"] = true,
			["id_103596"] = true,
			["id_103440"] = true,
			["id_103597"] = true,
			["id_103549"] = true,
			["id_103603"] = true,
			["id_103579"] = true,
			["id_103625"] = true
		}
		local _pig_instance_name = {
			"dinner_triple_meat_001",
			"dinner_triple_meat_001",
			"dinner_triple_meat_002",
			"dinner_triple_meat_003",
			"dinner_triple_meat_004",
			"dinner_triple_meat_005",
			"dinner_triple_meat_006",
			"dinner_triple_meat_007",
			"dinner_triple_meat_008",
			"dinner_triple_meat_009",
			"dinner_triple_meat_010",
			"dinner_triple_meat_011",
			"dinner_triple_meat_012",
			"dinner_triple_meat_013",
			"dinner_triple_meat_014",
			"dinner_triple_meat_015",
			"dinner_triple_meat_016",
			"dinner_quad_meat_001",
			"dinner_quad_meat_002",
			"dinner_quad_meat_003",
			"dinner_quad_meat_004",
			"dinner_quad_meat_005",
			"dinner_quad_meat_006",
			"dinner_quad_meat_007",
			"dinner_quad_meat_008",
			"dinner_quad_meat_009",
			"dinner_quad_meat_010",
			"dinner_quad_meat_011",
			"dinner_quad_meat_012",
			"dinner_quad_meat_013"
		}
		local _id = "id_" .. tostring(self._id)
		if _id_specify[_id] then
			_more_pig_do_once = true
			for _, pig in ipairs(_pig_instance_name) do
				local input_elements = managers.world_instance:get_registered_input_elements(pig, "Activate special pig")
				if input_elements then
					for _, element in ipairs(input_elements) do
						element:on_executed(instigator)
					end
				end
			end
		end
	end
	_f_ElementInstanceInputEvent_on_executed(self, instigator)
end