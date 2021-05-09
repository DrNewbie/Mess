core:module("CoreSequenceManager")
core:import("CoreEngineAccess")
core:import("CoreLinkedStackMap")
core:import("CoreTable")
core:import("CoreUnit")
core:import("CoreClass")

local __is_host = Network and Network:is_server() or Global.game_settings.single_player

local __special_key_ids = "V_"..Idstring("var_req_re_this_planks::1"):key()

Hooks:PostHook(SetVariablesElement, "set_variable", "F_"..Idstring("PostHook::TESTTT"):key(), function(self, env, name, value)
	if __is_host and tostring(name) == __special_key_ids then
		local __unit = env.dest_unit
		local planks_body = __unit:body("planks_body")
		if planks_body then
			local them = __unit:damage()
			if type(them.__special_req_re_this_planks) == "function" then
				them:__special_req_re_this_planks()
			end
		end
	end
end)