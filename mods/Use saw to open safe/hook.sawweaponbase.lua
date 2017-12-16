Hooks:PostHook(SawHit, "on_collision", "UseSaw2OpenSafe", function(self, col_ray, weapon_unit, user_unit, damage)
	local hit_unit = col_ray and col_ray.unit or nil
	if hit_unit and hit_unit:base() then
		if type(damage) == "number" and hit_unit:base() and hit_unit:base().tweak_data then
			local td = tostring(hit_unit:base().tweak_data)
			if type(hit_unit:base()._addon_saw_open_init) ~= "number" then
				local health = 0
				if td:find("safe") then
					health = 100
					if td:find("titan") then health = health + 200 end
					if td:find("giga") then health = health + 100 end
					if td:find("large") then health = health + 50 end
					if td:find("90sec") then health = health + 45 end
					if td:find("60sec") then health = health + 30 end
					if td:find("cas") then health = health + 100 end
				end
				if health > 0 then
					hit_unit:base()._addon_saw_open_init = 1
					hit_unit:base()._addon_saw_open_health = health
				else
					hit_unit:base()._addon_saw_open_init = 2
				end
			else
				if hit_unit:base()._addon_saw_open_init == 2 then
					return
				end
			end
			if type(hit_unit:base()._addon_saw_open_init) == "number" and hit_unit:base()._addon_saw_open_init == 1 and type(hit_unit:base()._addon_saw_open_health) == "number" then
				if hit_unit:base()._addon_saw_open_health > 0 then
					hit_unit:base()._addon_saw_open_health = hit_unit:base()._addon_saw_open_health - damage
				else
					hit_unit:base()._addon_saw_open_init = 2
					hit_unit:base()._addon_saw_open_health = nil
					if type(hit_unit:base()._devices) == "table" then
						for _type, _ in pairs(hit_unit:base()._devices) do
							hit_unit:base():device_completed(_type)
						end
					end
				end
			end
		end
	end
end)