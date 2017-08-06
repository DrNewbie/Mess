if Network:is_client() then
	return
end

local _f_PlayerStandard_do_melee_damage = PlayerStandard._do_melee_damage

function PlayerStandard:_do_melee_damage(...)
	local col_ray = _f_PlayerStandard_do_melee_damage(self, ...)
	if col_ray and col_ray.unit and alive(col_ray.unit) and 
		(col_ray.unit:name():key() == "c71d763cd8d33588" or
		col_ray.unit:name():key() == "b1f544e379409e6c") then
		local ammo_total = col_ray.unit:weapon():ammo_total()
		local ammo_max = col_ray.unit:weapon():ammo_max()
		local _rate_per_hit = 0.05
		if ammo_total*(1 + _rate_per_hit) < ammo_max then
			local _take_ammo = take_ammo()
			if _take_ammo then
				col_ray.unit:base():refill(_rate_per_hit)
			end
		end
	end
end

function take_ammo()
	local weapon_list = {}
	local ammo_reduction = 0.1
	local leftover = 0
	local _success = false
	for id, weapon in pairs(managers.player:player_unit():inventory():available_selections()) do
		local ammo_ratio = weapon.unit:base():get_ammo_ratio()
		if ammo_reduction > ammo_ratio then
			leftover = leftover + ammo_reduction - ammo_ratio
			weapon_list[id] = {
				unit = weapon.unit,
				amount = ammo_ratio,
				total = ammo_ratio
			}
		else
			weapon_list[id] = {
				unit = weapon.unit,
				amount = ammo_reduction,
				total = ammo_ratio
			}
		end
	end
	for id, data in pairs(weapon_list) do
		local ammo_left = data.total - data.amount
		if leftover > 0 and ammo_left > 0 then
			local extra_ammo = leftover > ammo_left and ammo_left or leftover
			leftover = leftover - extra_ammo
			data.amount = data.amount + extra_ammo
		end
		if 0 < data.amount then
			data.unit:base():reduce_ammo_by_procentage_of_total(data.amount)
			managers.hud:set_ammo_amount(id, data.unit:base():ammo_info())
			_success = true
		end
	end
	return _success
end