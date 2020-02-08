local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Network and Network:is_server() then
	local kpr_original_copactionwarp_init = CopActionWarp.init
	function CopActionWarp:init(...)
		local result = kpr_original_copactionwarp_init(self, ...)
		if result and self._unit:base().kpr_is_keeper then
			local gstate = managers.groupai:state()
			local u_key = self._unit:key()
			if gstate:all_AI_criminals()[u_key] or gstate:all_converted_enemies()[u_key] then
				Keepers:SendState(self._unit, Keepers:GetLuaNetworkingText(false, self._unit), false)
			end
		end
		return result
	end
end
