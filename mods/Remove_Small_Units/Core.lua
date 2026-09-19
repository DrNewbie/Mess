core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
WorldDefinition = WorldDefinition or class()
--[[
	Offline-Only
]]
if Global.load_level == true and Global.game_settings and Global.game_settings.single_player then
	--[[
		don't remove some units
	]]
	local function __check_unit_type(__unit)
		if not __unit or type(__unit) ~= "userdata" or not alive(__unit) or type(__unit.oobb) ~= "function" or not __unit:oobb() or not __unit:oobb():size() then
			return false
		end
		if __unit.interaction and __unit:interaction() then
			return false
		end
		if __unit.damage and __unit:damage() then
			return false
		end
		if __unit:slot() ~= 1 then
			return false
		end
		return true
	end
	--[[
		X * Y * Z = size
	]]
	local function __get_unit_size(__unit)
		local oobb_size = __unit:oobb():size()
		return (math.max(1, oobb_size.x) * math.max(1, oobb_size.y) * math.max(1, oobb_size.z)) ^ (1 / 3)
	end
	--[[
		Insert unit to list
	]]
	local old_make_unit = WorldDefinition.make_unit
	_G.LessUnitReayToCheckSize = _G.LessUnitReayToCheckSize or {}
	function WorldDefinition:make_unit(...)
		local __unit = old_make_unit(self, ...)
		if __check_unit_type(__unit) then
			local __size = __get_unit_size(__unit)
			if __size > 0 then
				_G.LessUnitReayToCheckSize[__unit:key()] = {unit = __unit, size = __size}
			end
		end
		return __unit
	end
end