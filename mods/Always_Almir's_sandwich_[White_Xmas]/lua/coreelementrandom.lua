core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

if not Global.game_settings then
	return
end

local mod_ids = Idstring("Always Almir's sandwich [White Xmas]"):key()
local hook1 = "H_"..Idstring("ElementRandom:on_executed:"..mod_ids):key()
local hook2 = "H_"..Idstring("ElementRandom:init:"..mod_ids):key()
local bool1 = "B_"..Idstring(hook2.."::"..mod_ids):key()

Hooks:PreHook(ElementRandom, "on_executed", hook1, function(self)
	if managers.job:current_job_id() == "pines" then
		if self[bool1] and self:editor_name() == "choose_what_to_spawn" then
			local match_ele_data = nil
			for i, element_data in pairs(self._original_on_executed) do
				local ele = self:get_mission_element(element_data.id)
				if ele and ele:editor_name() == "spawn_sand_link" then
					match_ele_data = element_data
				end
			end
			if match_ele_data then
				for i, element_data in pairs(self._original_on_executed) do
					self._original_on_executed[i] = match_ele_data
				end
			end
		end
	end
end)

Hooks:PostHook(ElementRandom, "init", hook2, function(self, mission_script, data)
	if managers.job:current_job_id() == "pines" then
		if type(data) == "table" and type(data.values) == "table" then
			if tostring(data.values.instance_name):find("san_box001_0") or tostring(data.values.instance_name):find("san_box_tree001_0") then
				self[bool1] = true
			end
		end
	end
end)