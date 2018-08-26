core:module("CoreElementCounter")
core:import("CoreMissionScriptElement")
core:import("CoreClass")

if not ElementCounter then
	return	
end

local SkirmishMoreWaveAmount = 99

local Alt_Ele_39e3089c65be46a0 = Alt_Ele_39e3089c65be46a0 or ElementCounter.on_executed
local Rec_Ele_39e3089c65be46a0 = Rec_Ele_39e3089c65be46a0 or {}
function ElementCounter:on_executed(...)
	if managers and managers.skirmish and managers.skirmish:is_skirmish() then
		if (self._editor_name == "counter_final_wave" or self._editor_name == "counter_final_wave_completed") and not Rec_Ele_39e3089c65be46a0[self._editor_name] then
			Rec_Ele_39e3089c65be46a0[self._editor_name] = true
			self._values.counter_target = SkirmishMoreWaveAmount
		end
	end
	Alt_Ele_39e3089c65be46a0(self, ...)
end