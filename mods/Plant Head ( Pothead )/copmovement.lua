function CopMovement:Re_Check_Plant_Head()
	local __Plant_Head = "units/pd2_dlc2/props/bnk_prop_lobby_plant_dracaenafragrans/bnk_prop_lobby_plant_dracaenafragrans_b"
	if not DB:has(Idstring("unit"), Idstring(__Plant_Head)) or not PackageManager:unit_data(Idstring(__Plant_Head)) then
	
	else
		local them = self._unit:inventory()
		if alive(them._mask_unit) then
			for _, __linked_unit in ipairs(them._mask_unit:children()) do
				__linked_unit:unlink()
				World:delete_unit(__linked_unit)
			end
			them._mask_unit:unlink()
			World:delete_unit(them._mask_unit)
			them._mask_unit = nil
			return self:Re_Check_Plant_Head()
		else
			local __mask_align = them._unit:get_object(Idstring("Head"))
			if not __mask_align then
			
			else
				local __mask_unit = World:spawn_unit(Idstring(__Plant_Head), __mask_align:position(), __mask_align:rotation())
				if not __mask_unit or not alive(__mask_unit) then
				
				else
					them._unit:link(__mask_align:name(), __mask_unit, __mask_unit:orientation_object():name())
					them._mask_unit = __mask_unit
					them._mask_unit:set_rotation(Rotation())
				end
			end
		end
	end
end

Hooks:PostHook(CopMovement, "set_character_anim_variables", "F_"..Idstring("PostHook:CopMovement:set_character_anim_variables:Plant Head:PwP"):key(), function(self)
	if self._unit and self._unit:inventory() then
		self:Re_Check_Plant_Head()
	end
end)