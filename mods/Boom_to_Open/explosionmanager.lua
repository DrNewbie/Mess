local __slot_mask = World:make_slot_mask(1, 2, 8, 11, 12, 14, 17, 18, 21, 22, 25, 26, 33, 34, 35, 39)
local __skip_check = {
	[Idstring("units/payday2/props/gen_prop_bank_atm_standing/gen_prop_bank_atm_standing"):key()] = {
		["activate_door"] = true,
		["generic"] = true
	},
	[Idstring("units/payday2/architecture/ind/ind_ext_level/ind_ext_fence_door"):key()] = {
		["activate_door"] = true
	},
	[Idstring("units/payday2/architecture/com_int_gallery/com_int_gallery_wall_painting_bars"):key()] = {
		["nil"] = true
	},
	[Idstring("units/payday2/vehicles/str_vehicle_truck_boxvan_eday/str_vehicle_truck_boxvan_eday"):key()] = {
		["nil"] = true
	},
	[Idstring("units/pd2_dlc_pex/props/pex_prop_interrogation_table/pex_prop_interrogation_table"):key()] = {
		["nil"] = true
	},
	[Idstring("units/payday2/architecture/ind/ind_ext_outdoor_stairs/ind_fence_yellow_door"):key()] = {
		["nil"] = true
	},
	[Idstring("units/payday2/vehicles/eus_vehicle_train/eus_interactable_door_cargo"):key()] = {
		["activate_door"] = true
	},
	[Idstring("units/payday2/architecture/ind/ind_ext_outdoor_stairs/ind_fence_yellow_door_new"):key()] = {
		["deactivate_door"] = true
	}
}

Hooks:PostHook(ExplosionManager, "detect_and_give_dmg", Idstring("Boom to Open:ExplosionManager:detect_and_give_dmg"):key(), function(self, params)
	if managers.player:local_player() and type(params) == "table" and params.hit_pos then
		local hit_pos = params.hit_pos
		local dmg = params.damage or 0
		if hit_pos and dmg then
			local __fix_from_dmg = math.clamp(dmg/600, 0.00001, 1)
			local units = World:find_units("sphere", hit_pos, 300*__fix_from_dmg, __slot_mask, "ray_type", "body bullet lock")
			if type(units) == "table" and units[1] then
				for id, hit_unit in pairs(units) do
					if hit_unit:damage() and type(hit_unit:num_bodies()) == "number" then
						local __run_check = false
						--[[
						log("key: " .. hit_unit:name():key())
						if hit_unit.interaction then
							log("	hit_unit.interaction")
						end
						if hit_unit.interaction and hit_unit:interaction() then
							log("	hit_unit:interaction()")
						end
						if hit_unit.interaction and hit_unit:interaction() and not hit_unit:interaction():disabled() then
							log("	not hit_unit:interaction():disabled()")
						end
						if hit_unit.interaction and hit_unit:interaction() and not hit_unit:interaction():disabled() and not hit_unit:interaction():active() then
							log("	hit_unit:interaction():active()")
						end
						]]
						if hit_unit.interaction and hit_unit:interaction() and not hit_unit:interaction():disabled() and hit_unit:interaction():active() then
							__run_check = true
						elseif __skip_check[hit_unit:name():key()] and __skip_check[hit_unit:name():key()][tostring(hit_unit:unit_data().mesh_variation)] then
							__run_check = true
						else
							--log("		mesh_variation: " .. tostring(hit_unit:unit_data().mesh_variation))
						end
						if __run_check then
							for i = 0, hit_unit:num_bodies() - 1 do
								local body = hit_unit:body(i)
								if body:extension() and body:extension().damage and body:extension().damage:endurance_exists("lock") then
									--[[
									if hit_unit:damage():has_sequence("state_spawn_nothing") then
										if math.random() > 0.3 then
											hit_unit:damage():run_sequence_simple("state_spawn_nothing")
										end
									end
									]]
									body:extension().damage:damage_lock(
										managers.player:local_player(), 
										math.UP, 
										hit_unit:position(), 
										hit_unit:rotation():y(), 
										1000*__fix_from_dmg
									)
									if hit_unit:id() ~= -1 then
										managers.network:session():send_to_peers_synched("sync_body_damage_lock", body, 1000*__fix_from_dmg)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)