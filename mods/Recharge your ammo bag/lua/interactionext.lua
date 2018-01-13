local function is_Ply_AmmoBag_second_interact(them, player)
	if them._unit:name():key() == Idstring("units/payday2/equipment/gen_equipment_ammobag/gen_equipment_ammobag"):key() then
		if player and alive(player) then
			local PlyStandard = player:movement() and player:movement()._states.standard or nil
			if PlyStandard then
				return PlyStandard:use_second_interact()
			end
		end
	end
	return false
end

local AmmoBagInteractionExt_interact_Orrr = AmmoBagInteractionExt.interact
function AmmoBagInteractionExt:interact(player)
	if is_Ply_AmmoBag_second_interact(self, player) then
		AmmoBagInteractionExt.super.super.interact(self, player)
		self._unit:base():take_ammo(player, true)
		return true
	end
	return AmmoBagInteractionExt_interact_Orrr(self, player)
end

local AmmoBagInteractionExt_interact_blocked_Orrr = AmmoBagInteractionExt._interact_blocked
function AmmoBagInteractionExt:_interact_blocked(player)
	if is_Ply_AmmoBag_second_interact(self, player) then
		return false
	end
	return AmmoBagInteractionExt_interact_blocked_Orrr(self, player)
end

local AmmoBagInteractionExt_selected_Orrr = AmmoBagInteractionExt.selected
function AmmoBagInteractionExt:selected(player)
	local Ans = AmmoBagInteractionExt_selected_Orrr(self, player)
	if is_Ply_AmmoBag_second_interact(self, player) then
		managers.hud:show_interact({
			text ="Hold <Interact Key> to Insert Ammo",
			icon = self.no_equipment_icon or self._tweak_data.no_equipment_icon or self._tweak_data.icon
		})
	end
	return Ans
end