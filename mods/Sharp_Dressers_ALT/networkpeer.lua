if not PackageManager:loaded("packages/dlcs/sah/job_sah") then
	PackageManager:load("packages/dlcs/sah/job_sah") 
end

Hooks:PostHook(NetworkPeer, "_update_equipped_armor", "Dr_Newbie_CustomArmourPackage__update_equipped_armor", function(self)
	if not alive(self._unit) then
		return
	end
	local unit_damage = self._unit and self._unit:damage() or nil
	if unit_damage and unit_damage:has_sequence("spawn_prop_tux") then
		unit_damage:run_sequence_simple("spawn_prop_tux")
	end
end)