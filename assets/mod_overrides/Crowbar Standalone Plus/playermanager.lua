Hooks:PostHook(PlayerManager, "_internal_load", "F_"..Idstring("PostHook:PlayerManager:_internal_load:Crowbar Standalone Plus"):key(), function(self)
	if tostring(managers.blackmarket:equipped_melee_weapon()) == 'mla_crowbar' then
		self:add_equipment({
				silent = true,
				equipment = 'crowbar'
			}
		)
	end
end)

Hooks:PostHook(PlayerManager, "remove_equipment", "F_"..Idstring("PostHook:PlayerManager:remove_equipment:Crowbar Standalone Plus"):key(), function(self, equipment_id)
	if tostring(managers.blackmarket:equipped_melee_weapon()) == 'mla_crowbar' and tostring(equipment_id) == 'crowbar' then
		self:add_equipment({
				silent = true,
				equipment = 'crowbar'
			}
		)
	end
end)