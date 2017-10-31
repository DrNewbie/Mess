core:module("CoreElementInstance")
core:import("CoreMissionScriptElement")

ElementInstanceInputEvent = ElementInstanceInputEvent or class(CoreMissionScriptElement.MissionScriptElement)

if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "dah" then
	return
end

_G.DiamondHeistHelper = _G.DiamondHeistHelper or {}

local DiamondHeistHelper = _G.DiamondHeistHelper

DiamondHeistHelper._KeypadAns = DiamondHeistHelper._KeypadAns or {Red = -1, Green = -1, Blue = -1}

local DiamondHeistHelper_KeypadAns = ElementInstanceInputEvent.on_executed
function ElementInstanceInputEvent:on_executed(...)
	if self._id == 100001 and self._editor_name == "Enable_keypad_Interaction" then
		DiamondHeistHelper._KeypadAnsEnable = true
		DiamondHeistHelper:KeypadAnsShow()
	elseif self._id == 100023 and self._editor_name == "Disable_keypad_Interaction" then
		DiamondHeistHelper._KeypadAnsEnable = false
	elseif self._id == 103264 then
		DiamondHeistHelper._KeypadAns.Red = 0
	elseif self._id == 103236 then
		DiamondHeistHelper._KeypadAns.Red = 1
	elseif self._id == 103238 then
		DiamondHeistHelper._KeypadAns.Red = 2
	elseif self._id == 103239 then
		DiamondHeistHelper._KeypadAns.Red = 3
	elseif self._id == 103242 then
		DiamondHeistHelper._KeypadAns.Red = 4
	elseif self._id == 103241 then
		DiamondHeistHelper._KeypadAns.Red = 5
	elseif self._id == 103240 then
		DiamondHeistHelper._KeypadAns.Red = 6
	elseif self._id == 103245 then
		DiamondHeistHelper._KeypadAns.Red = 7
	elseif self._id == 103244 then
		DiamondHeistHelper._KeypadAns.Red = 8
	elseif self._id == 103243 then
		DiamondHeistHelper._KeypadAns.Red = 9
	elseif self._id == 103265 then
		DiamondHeistHelper._KeypadAns.Green = 0
	elseif self._id == 103252 then
		DiamondHeistHelper._KeypadAns.Green = 1
	elseif self._id == 103253 then
		DiamondHeistHelper._KeypadAns.Green = 2
	elseif self._id == 103254 then
		DiamondHeistHelper._KeypadAns.Green = 3
	elseif self._id == 103248 then
		DiamondHeistHelper._KeypadAns.Green = 4
	elseif self._id == 103250 then
		DiamondHeistHelper._KeypadAns.Green = 5
	elseif self._id == 103251 then
		DiamondHeistHelper._KeypadAns.Green = 6
	elseif self._id == 103246 then
		DiamondHeistHelper._KeypadAns.Green = 7
	elseif self._id == 103247 then
		DiamondHeistHelper._KeypadAns.Green = 8
	elseif self._id == 103249 then
		DiamondHeistHelper._KeypadAns.Green = 9
	elseif self._id == 103266 then
		DiamondHeistHelper._KeypadAns.Blue = 0
	elseif self._id == 103259 then
		DiamondHeistHelper._KeypadAns.Blue = 1
	elseif self._id == 103261 then
		DiamondHeistHelper._KeypadAns.Blue = 2
	elseif self._id == 103263 then
		DiamondHeistHelper._KeypadAns.Blue = 3
	elseif self._id == 103256 then
		DiamondHeistHelper._KeypadAns.Blue = 4
	elseif self._id == 103258 then
		DiamondHeistHelper._KeypadAns.Blue = 5
	elseif self._id == 103262 then
		DiamondHeistHelper._KeypadAns.Blue = 6
	elseif self._id == 103255 then
		DiamondHeistHelper._KeypadAns.Blue = 7
	elseif self._id == 103257 then
		DiamondHeistHelper._KeypadAns.Blue = 8
	elseif self._id == 103260 then
		DiamondHeistHelper._KeypadAns.Blue = 9
	end
	return DiamondHeistHelper_KeypadAns(self, ...)
end

ElementInstanceOutputEvent = ElementInstanceOutputEvent or class(CoreMissionScriptElement.MissionScriptElement)

local DiamondHeistHelper_Stop = ElementInstanceOutputEvent.on_executed
function ElementInstanceOutputEvent:on_executed(...)
	if not self._values.enabled then
		return
	end	
	if self._id == 101342 then
		DiamondHeistHelper._KeypadAnsEnable = false
	end
	DiamondHeistHelper_Stop(self, ...)
end