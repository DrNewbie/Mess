function PlayerEquipment:use_pocket_tank_mini()
	local ray = self:valid_shape_placement("doctor_bag")
	if ray then
		if Network:is_client() then
		
		else
			local pos = ray.position
			local ply = managers.player:player_unit()
			local rot = Rotation(ray.normal, math.UP)
			local unit = World:spawn_unit(Idstring("units/payday2/equipment/gen_equipment_tripmine/gen_equipment_pocket_tank_mini"), pos, ply:rotation())
			unit:set_slot(12)
			unit:movement():set_team(managers.groupai:state():team_data(tweak_data.levels:get_default_team_ID("combatant")))
			unit:brain():set_active(false)
			managers.groupai:state():convert_hostage_to_criminal_new(unit, ply)
			unit:character_damage():set_invulnerable(true)
		end
		return true
	end
	return false
end