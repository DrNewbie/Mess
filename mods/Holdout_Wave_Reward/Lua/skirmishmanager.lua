function SkirmishManager:Spawn_Holdout_Wave_Reward()
	if not self:is_skirmish() then
		
	else
		if (Network and Network:is_server()) or Global.game_settings.single_player then
			local __civilians = World:find_units_quick("all", managers.slot:get_mask("civilians"))
			if __civilians then
				local __spawn_ammo_bag = function(__pos, __rot)
					ThisFakeAmmoBagBase.spawn(__pos + Vector3(100, 0, 0), Rotation(), nil, nil, 30)
					return
				end
				local __spawn_medic_bag = function(__pos, __rot)				
					ThisFakeDoctorBagBase.spawn(__pos + Vector3(0, 100, 0), Rotation(), nil, 30)
					return
				end
				local __spawn_grenade_crate = function(__pos, __rot)				
					ThisFakeGrenadeCrateBase.spawn(__pos + Vector3(-100, 0, 0), Rotation(), 30)
					return
				end
				for __, __unit in pairs(__civilians) do
					if __unit and alive(__unit) then
						pcall(__spawn_ammo_bag, __unit:position())
						pcall(__spawn_medic_bag, __unit:position())
						pcall(__spawn_grenade_crate, __unit:position())
					end
				end
			end
		end
	end
	return
end