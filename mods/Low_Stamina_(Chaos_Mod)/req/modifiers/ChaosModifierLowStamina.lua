ChaosModifierLowStamina = ChaosModifier.class("ChaosModifierLowStamina")
ChaosModifierLowStamina.run_as_client = true
ChaosModifierLowStamina.duration = 30

function ChaosModifierLowStamina:update(t, dt)
	if not managers.player then
		return
	end
	local player_unit = managers.player:local_player()
	if not player_unit or not alive(player_unit) then
		return
	end
	player_unit:movement():subtract_stamina(1)
end

return ChaosModifierLowStamina