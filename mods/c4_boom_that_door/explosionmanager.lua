Hooks:PostHook(ExplosionManager, "detect_and_give_dmg", Idstring("C4Boom:ExplosionManager:detect_and_give_dmg"):key(), function(self, params)
	local hit_pos = type(params) == "table" and params.hit_pos or nil
	local slotmask = params.collision_slotmask
	local dmg = params.damage or nil
	if hit_pos and dmg then
		local units = World:find_units("sphere", hit_pos, 300, slotmask or managers.slot:get_mask("bullet_impact_targets"))
		if type(units) == "table" and units[1] then
			for id, hit_unit in pairs(units) do
				if hit_unit:base() and type(hit_unit:base()._devices) == "table" and type(hit_unit:base()._devices.c4) == "table" and type(hit_unit:base()._devices.c4.amount) == "number" then
					if not hit_unit:base()._devices.c4.max_health then
						hit_unit:base()._devices.c4.max_health = hit_unit:base()._devices.c4.amount * 500
					end
					if hit_unit:base()._devices.c4.max_health then
						hit_unit:base()._devices.c4.max_health = hit_unit:base()._devices.c4.max_health - dmg
						if hit_unit:base()._devices.c4.max_health <= 0 then
							hit_unit:base():device_completed("c4")
						end
					end
					break
				end
			end
		end
	end
end)