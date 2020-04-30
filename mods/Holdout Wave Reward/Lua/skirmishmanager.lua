function SkirmishManager:Spawn_Holdout_Wave_Reward()
	if not self:is_skirmish() then
		
	else
		if (Network and Network:is_server()) or Global.game_settings.single_player then
			local __civilians = World:find_units_quick("all", managers.slot:get_mask("civilians"))
			if __civilians then
				local __spawn_ammo_bag = function(__pos, __rot)
					local __unit_name = "units/payday2/equipment/gen_equipment_ammobag/gen_equipment_ammobag"
					local __spawn_unit = World:spawn_unit(Idstring(__unit_name), __pos, __rot)
					if __spawn_unit then
						__spawn_unit:base():setup(0)
						if __spawn_unit:body("dynamic") ~= nil then
							__spawn_unit:base()._is_dynamic = true
							__spawn_unit:body("dynamic"):set_enabled(true)
							if managers.network:session() then
								managers.network:session():send_to_peers_synched("sync_ammo_bag_setup", __spawn_unit, 0, 0, 0)
								managers.network:session():send_to_peers_synched("sync_unit_event_id_16", __spawn_unit, "base", 1)
							end
							__spawn_unit:push(5, math.UP * 1000)
						end
					end
				end
				for __, __unit in pairs(__civilians) do
					if __unit and alive(__unit) then
						__spawn_ammo_bag(__unit:position(), __unit:rotation())
					end
				end
			end
		end
	end
	return
end