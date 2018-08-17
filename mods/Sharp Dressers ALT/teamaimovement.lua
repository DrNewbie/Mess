if not PackageManager:loaded("packages/dlcs/sah/job_sah") then
	PackageManager:load("packages/dlcs/sah/job_sah") 
end

Hooks:PostHook(TeamAIMovement, "check_visual_equipment", "SharpDressers_check_visual_equipment", function(self)
	local unit_damage = self._unit:damage()
	if unit_damage and unit_damage:has_sequence("spawn_prop_tux") then
		unit_damage:run_sequence_simple("spawn_prop_tux")
	end
end)