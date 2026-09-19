if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "dah" then
	return
end

local DiamondHeistHelper_Lap_Bool = false
local DiamondHeistHelper_HackBox_Bool = false

_G.DiamondHeistHelper = _G.DiamondHeistHelper or {}

function DiamondHeistHelper:KeypadAnsShow()
	self._KeypadAns = self._KeypadAns or {}
	local _r, _g, _b = self._KeypadAns.Red or -1, self._KeypadAns.Green or -1, self._KeypadAns.Blue or -1
	local _msg = string.format("[Helper]: Red = %s, Green = %s, Blue = %s", _r == -1 and '?' or ''.._r, _g == -1 and '?' or ''.._g, _b == -1 and '?' or ''.._b)
	managers.chat:send_message(ChatManager.GAME, "", _msg)
	managers.hud:show_hint({text = _msg})
end

Hooks:PostHook(DialogManager, "queue_dialog", "DiamondHeistHelper", function()
	local _runE = function (_run)
		local _runList = {}
		for _, script in pairs(managers.mission:scripts()) do
			for idx, element in pairs(script:elements()) do
				idx = tostring(idx)
				if table.contains(_run, idx) then
					if element then
						table.insert(_runList, element)
					end
				end
			end
		end
		for _, element in pairs(_runList) do
			element:on_executed()
		end
	end
	if not Utils:IsInHeist() or not managers.groupai:state():whisper_mode() then
		return
	end
	if not DiamondHeistHelper_Lap_Bool then
		DiamondHeistHelper_Lap_Bool = true
		DelayedCalls:Add('DiamondHeistHelper_Outline', 5, function()
			_runE({
				'102952',
				'102954',
				'102953',
				'102962',
				'104308'
			})
		end)
		return
	end
	if DiamondHeistHelper._KeypadAnsEnable and DiamondHeistHelper._KeypadAns then
		DiamondHeistHelper:KeypadAnsShow()	
	end
end)