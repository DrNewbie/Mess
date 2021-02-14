Hooks:PostHook(ExplosionManager, "detect_and_give_dmg", Idstring("Boom to Open:ExplosionManager:detect_and_give_dmg"):key(), function(self, params)
	if managers.player:local_player() then
		local hit_pos = type(params) == "table" and params.hit_pos or nil
		local dmg = params.damage or nil
		if hit_pos and dmg and dmg > 60 then
			local units = World:find_units("sphere", hit_pos, 300, managers.slot:get_mask("all"), "ray_type", "body bullet lock")
			if type(units) == "table" and units[1] then
				for id, hit_unit in pairs(units) do
					if hit_unit:damage() and type(hit_unit:num_bodies()) == "number" then
						for i = 0, hit_unit:num_bodies() - 1 do
							local body = hit_unit:body(i)
							if body:extension() and body:extension().damage and body:extension().damage:endurance_exists("lock") then
								if hit_unit:damage():has_sequence("state_spawn_nothing") then
									if math.random() > 0.3 then
										hit_unit:damage():run_sequence_simple("state_spawn_nothing")
									end
								end
								body:extension().damage:damage_lock(
									managers.player:local_player(), 
									math.UP, 
									hit_unit:position(), 
									hit_unit:rotation():y(), 
									10000000
								)
							end
						end
					end
				end
			end
		end
	end
end)