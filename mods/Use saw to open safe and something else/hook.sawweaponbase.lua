Hooks:PostHook(SawHit, "on_collision", "F_"..Idstring("PostHook:SawHit:on_collision:UseSaw2OpenMoreSafeAndElse"), function(self, col_ray, weapon_unit, user_unit, damage)
	local hit_unit = col_ray and col_ray.unit or nil
	if hit_unit and hit_unit:base() then
		if type(damage) == "number" and hit_unit:base() and hit_unit:base().tweak_data then
			local td = string.lower(tostring(hit_unit:base().tweak_data))
			if not hit_unit:base()._addon_saw_unable_open then
				local devices_data = tweak_data.mission_door[td].devices
				if type(hit_unit:base()._addon_saw_open_init) ~= "number" then
					local health = 0
					if td:find("safe") then
						health = 100
						if td:find("giga") then health = health + 100 end
						if td:find("large") then health = health + 50 end
						if td:find("90sec") then health = health + 45 end
						if td:find("60sec") then health = health + 30 end
						if td:find("cas") then health = health + 100 end
						if td:find("titan") then health = -1 end
					elseif td:find("keycard_ecm") then
						health = 100
					elseif devices_data.c4 then
						health = 50
						for i, _ in pairs(devices_data.c4) do
							health = health + 25
						end
					else
						hit_unit:base()._addon_saw_unable_open = true
						return
					end
					if type(hit_unit:base()._devices) ~= "table" then
						hit_unit:base()._addon_saw_unable_open = true
						return
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
							local is_ok
							if hit_unit:base()._devices.drill then
							
							end
							for _, _type in pairs({"drill", "key", "c4"}) do
								if hit_unit:base()._devices[_type] then
									hit_unit:base():device_completed(_type)
									is_ok = true
									break
								end
							end
							if not is_ok then
								if hit_unit:interaction() and hit_unit:interaction():active() and not hit_unit:interaction():disabled() then
									local _unit_inter_ex = hit_unit:interaction()
									_unit_inter_ex:interact(managers.player:local_player())
									_unit_inter_ex:interact_interupt(managers.player:local_player())
								end
							end
						end
					end
				end
			end
		end
	end
end)