local this_size_limit = type(LessUnitMainClassFunction) == "table" and type(LessUnitMainClassFunction.Options) == "table" and type(LessUnitMainClassFunction.Options.GetValue) == "function" and LessUnitMainClassFunction.Options:GetValue("__size_limit") or 25
local this_total_removed = 0
local function this_function_run()
	_G.LessUnitReayToCheckSize = _G.LessUnitReayToCheckSize or {}
	if not table.empty(_G.LessUnitReayToCheckSize) then
		for __i, __d in pairs(_G.LessUnitReayToCheckSize) do
			if type(__d) == "table" and __d.unit and __d.size then
				if __d.size > 0 and __d.size <= this_size_limit then
					this_total_removed = this_total_removed + 1
					if alive(__d.unit) then
						log("[Less Units]: ", tostring(__d.unit), tostring(__d.size), this_total_removed)
					end
					if alive(__d.unit) then
						__d.unit:set_slot(0)
					end
					if alive(__d.unit) then
						World:delete_unit(__d.unit)
					end
				end
			end
			_G.LessUnitReayToCheckSize[__i] = nil
		end
	end
	return
end
Hooks:PostHook(PlayerManager, "update", "LessUnitReayToCheckSizeLoop", function(...)	
	if type(_G.LessUnitReayToCheckSize) == "table" and not table.empty(_G.LessUnitReayToCheckSize) then
		pcall(this_function_run)
	end
end)