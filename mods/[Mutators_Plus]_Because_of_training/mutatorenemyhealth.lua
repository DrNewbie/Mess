function MutatorEnemyHealth:name()
	local name = MutatorEnemyHealth.super.name(self)
	if self:_mutate_name("health_multiplier") then
		return string.format("%s - %6.1f%%", name, tonumber(self:value("health_multiplier")) * 100)
	else
		return name
	end
end

function MutatorEnemyHealth:_min_health()
	return 0.001
end

function MutatorEnemyHealth:_max_health()
	return 1000
end