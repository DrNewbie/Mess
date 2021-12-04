core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

MissionScriptElement = MissionScriptElement or class()

local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local hook1 = "F_"..Idstring("hook1::"..ThisModIds):key()
local bool1 = "F_"..Idstring("bool1::"..ThisModIds):key()
local unit1 = "F_"..Idstring("unit1::"..ThisModIds):key()

if Network and Network:is_client() then

else
	if not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "mus" then

	else
		Hooks:PreHook(MissionScriptElement, "on_executed", hook1, function(self)
			if not self._values.enabled or not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "mus" then

			else
				if self._id == 100018 and not self[bool1] then
					self[bool1] = true
					for _, __script in pairs(managers.mission:scripts()) do
						for _, __element in pairs(__script:elements()) do
							if __element and tostring(__element._editor_name):find("set_valueable0") then
								__element._values.enabled = true
								__element:on_executed()
							end
						end
					end
				end
			end
		end)
	end
end