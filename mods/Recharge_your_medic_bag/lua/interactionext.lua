local function is_Ply_second_interact(them, player)
	if them._unit:name():key() == Idstring("units/payday2/equipment/gen_equipment_medicbag/gen_equipment_medicbag"):key() then
		if player and alive(player) then
			local PlyStandard = player:movement() and player:movement()._states.standard or nil
			if PlyStandard then
				return PlyStandard:use_second_interact()
			end
		end
	end
	return false
end

local DoctorBagBaseInteractionExt_interact_Orrr = DoctorBagBaseInteractionExt.interact
function DoctorBagBaseInteractionExt:interact(player)
	if is_Ply_second_interact(self, player) then
		DoctorBagBaseInteractionExt.super.super.interact(self, player)
		self._unit:base():take(player, true)
		return true
	end
	return DoctorBagBaseInteractionExt_interact_Orrr(self, player)
end

local DoctorBagBaseInteractionExt_interact_blocked_Orrr = DoctorBagBaseInteractionExt._interact_blocked
function DoctorBagBaseInteractionExt:_interact_blocked(player)
	if is_Ply_second_interact(self, player) then
		return false
	end
	return DoctorBagBaseInteractionExt_interact_blocked_Orrr(self, player)
end

local DoctorBagBaseInteractionExt_selected_Orrr = DoctorBagBaseInteractionExt.selected
function DoctorBagBaseInteractionExt:selected(player)
	local Ans = DoctorBagBaseInteractionExt_selected_Orrr(self, player)
	if is_Ply_second_interact(self, player) then
		managers.hud:show_interact({
			text ="Hold <Interact Key> to Insert Medic",
			icon = self.no_equipment_icon or self._tweak_data.no_equipment_icon or self._tweak_data.icon
		})
	end
	return Ans
end