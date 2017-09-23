local Mod4ModifySomething = function(them)
	local function _modify_v_delay(v)
		v = v or 0
		return 0.01 + v / 3
	end
	local function _modify_v_more(v, v_fix)
		v = v or 0
		v_fix = v_fix or 0
		return 1 + v * 6 + v_fix
	end
	local function _modify_v_little_more(v)
		v = v or 0
		return 0.5 + v * 1.75
	end
	local function _modify_v_per(v, v_fix)
		v = v or 0
		v_fix = v_fix or 0
		return 0.01 + v * v_fix
	end
	them.phalanx.spawn_chance.respawn_delay = _modify_v_delay(them.phalanx.spawn_chance.respawn_delay)
	them.besiege.recurring_group_SO.recurring_cloaker_spawn.retire_delay = _modify_v_delay(them.besiege.recurring_group_SO.recurring_cloaker_spawn.retire_delay)
	them.besiege.recon.interval_variation = _modify_v_delay(them.besiege.recon.interval_variation)
	for k, v in pairs(them.besiege.assault.delay) do
		them.besiege.assault.delay[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.assault.sustain_duration_min) do
		them.besiege.assault.sustain_duration_min[k] = _modify_v_more(v, -10)
	end
	for k, v in pairs(them.besiege.assault.sustain_duration_max) do
		them.besiege.assault.sustain_duration_max[k] = _modify_v_more(v)
	end
	for k, v in pairs(them.besiege.assault.sustain_duration_balance_mul ) do
		them.besiege.assault.sustain_duration_balance_mul [k] = _modify_v_little_more(v)
	end
	for k, v in pairs(them.besiege.recon.interval) do
		them.besiege.recon.interval[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.recurring_group_SO.recurring_cloaker_spawn.interval) do
		them.besiege.recurring_group_SO.recurring_cloaker_spawn.interval[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.recurring_group_SO.recurring_spawn_1.interval) do
		them.besiege.recurring_group_SO.recurring_spawn_1.interval[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.regroup.duration) do
		them.besiege.regroup.duration[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.assault.hostage_hesitation_delay) do
		them.besiege.assault.hostage_hesitation_delay[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.assault.force) do
		them.besiege.assault.force[k] = _modify_v_little_more(v)
	end
	for k, v in pairs(them.besiege.assault.force_balance_mul) do
		them.besiege.assault.force_balance_mul[k] = _modify_v_little_more(v)
	end
	for k, v in pairs(them.besiege.assault.force_pool_balance_mul) do
		them.besiege.assault.force_pool_balance_mul[k] = _modify_v_little_more(v)
	end
	for k, v in pairs(them.besiege.recon.interval) do
		them.besiege.recon.interval[k] = _modify_v_delay(v)
	end
	for k, v in pairs(them.besiege.recon.force) do
		them.besiege.recon.force[k] = _modify_v_more(v)
	end
	for k, v in pairs(them.special_unit_spawn_limits) do
		them.special_unit_spawn_limits[k] = math.clamp(math.round(_modify_v_more(v)), 1, 20)
	end
	for group_name, group_data in pairs(them.besiege.assault.groups) do
		for k, v in pairs(group_data) do
			them.besiege.assault.groups[group_name][k] = _modify_v_little_more(v)
		end
	end
	for group_name, group_data in pairs(them.enemy_spawn_groups) do
		for k, v in pairs(group_data) do
			if k == "amount" then
				for ki, vi in pairs(them.enemy_spawn_groups[group_name].amount) do
					them.enemy_spawn_groups[group_name].amount[ki] = math.round(_modify_v_more(vi))
				end
			elseif k == "spawn" then
				for ki, vi in pairs(them.enemy_spawn_groups[group_name].spawn) do
					for kj, vj in pairs(vi) do
						if kj == "amount_min" or kj == "amount_max" then
							them.enemy_spawn_groups[group_name].spawn[ki][kj] = math.round(_modify_v_more(vj))
						end
					end
				end
			end
		end
	end
	them.street = deep_clone(them.besiege)
end

Mod4ModifySomething(tweak_data.group_ai)