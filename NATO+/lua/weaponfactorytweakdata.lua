Hooks:PostHook(WeaponFactoryTweakData, "init", "WeaponFactoryTweakDatainit_NATOPLUS", function(wFac, ...)	
	local _parts_name = {}
	for k, v in pairs(wFac.parts or {}) do
		table.insert(_parts_name, k)
	end
	for k, v in pairs(wFac or {}) do
		if k ~= "parts" then
			local _npc_k = k .. "_npc"
			if wFac[_npc_k] and v.uses_parts and wFac[_npc_k].uses_parts then
				for _, v2 in pairs(_parts_name or {}) do
					table.insert(wFac[k].uses_parts, v2)
					table.insert(wFac[_npc_k].uses_parts, v2)					
				end
			end
		end
	end
end)