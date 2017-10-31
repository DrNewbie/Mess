core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")

local CloneClass = _G.CloneClass
_G.SurvivorModeBase = _G.SurvivorModeBase or {}
SurvivorModeBase = _G.SurvivorModeBase
SurvivorModeBase.Day2Escape = 0

_Net = _G and _G.LuaNetworking or nil

CloneClass( MissionScriptElement )

function MissionScriptElement.on_executed(self, instigator, alternative, skip_execute_on_executed)
	local _id = tostring(self._id)
	if SurvivorModeBase and SurvivorModeBase.Enable and not Network:is_client() then
		SurvivorModeBase:Load_Package("core")
		if SurvivorModeBase.isDay1 and _id == "100026" then
			managers.network:session():send_to_peers_synched("run_mission_element_no_instigator", 100234, 0)
			local element = self:get_mission_element(100234)
			self._mission_script:add(callback(element, element, "on_executed", instigator), 1, 1)
			log("[SurvivorMode]: Block , 100026")
			return
		end
		if (SurvivorModeBase.isDay1 and _id == "100236") or (not SurvivorModeBase.isDay1 and _id == "102444") then
			managers.groupai:state():set_point_of_no_return_timer(180, 0)
			SurvivorModeBase:Sync_Send("SurvivorMode_Sync_Check", SurvivorModeBase.Version)
			if SurvivorModeBase.isDay1 then
				SurvivorModeBase:Write_New_CharacterTweakData("escape_park")
			end
			SurvivorModeBase.Day2Escape = 0
		end
		if not SurvivorModeBase.isDay1 and _id == "100778" then
			if SurvivorModeBase.Day2Escape ~= -1 then
				SurvivorModeBase.Day2Escape = 100778
				SurvivorModeBase.Day2Escape_Element = self:get_mission_element(100778)
				SurvivorModeBase.Day2Escape_Instigator = instigator
				SurvivorModeBase.Day2Escape_Mission_Script = self._mission_script
				SurvivorModeBase.Day2EscapeBlock = 1
				log("[SurvivorMode]: Block , 100778")
				return
			end
		end
	end
	self.orig.on_executed(self, instigator, alternative, skip_execute_on_executed)
end