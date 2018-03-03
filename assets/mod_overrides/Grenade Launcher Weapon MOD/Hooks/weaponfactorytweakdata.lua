Hooks:PostHook(WeaponFactoryTweakData, "init", "GrenadeLauncherWeaponMOD_WFTDINIT", function(self)
	for k, v in pairs(self or {}) do
		if k ~= "parts" then
			local _npc_k = k .. "_npc"
			if self[_npc_k] and v.uses_parts and self[_npc_k].uses_parts then
				for _, v2 in pairs(v.uses_parts or {}) do
					if v2 == "wpn_fps_upg_i_singlefire" then
						table.insert(self[k].uses_parts, "wpn_grenade_launcher_mod")
						table.insert(self[_npc_k].uses_parts, "wpn_grenade_launcher_mod")
						break
					end
				end
			end
		end
	end
end)