core:module("CoreElementLogicChance")
core:import("CoreMissionScriptElement")

if not Global.game_settings then
	return
end

local mod_ids = Idstring("Always Almir's sandwich [White Xmas]"):key()
local hook1 = "H_"..Idstring("ElementLogicChance:on_executed:"..mod_ids):key()
local hook2 = "H_"..Idstring("ElementLogicChance:init:"..mod_ids):key()
local bool1 = "B_"..Idstring(hook2.."::"..mod_ids):key()

Hooks:PreHook(ElementLogicChance, "on_executed", hook1, function(self)
	if managers.job:current_job_id() == "pines" then
		if self[bool1] and self:editor_name() == "5_chance" then
			self._chance = 99999
		end
	end
end)


Hooks:PostHook(ElementLogicChance, "init", hook2, function(self, mission_script, data)
	if managers.job:current_job_id() == "pines" then
		if type(data) == "table" and type(data.values) == "table" then
			if tostring(data.values.instance_name):find("san_box001_0") or tostring(data.values.instance_name):find("san_box_tree001_0") then
				self[bool1] = true
			end
		end
	end
end)