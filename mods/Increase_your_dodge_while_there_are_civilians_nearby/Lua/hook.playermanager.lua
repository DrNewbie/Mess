function PlayerManager:is_less_targeted()
	if not self:player_unit() then
		return
	end
	for u_key, u_data in pairs(managers.enemy:all_civilians()) do
		if u_data.unit then
			local dis = math.abs(mvector3.distance(u_data.unit:position(), self:player_unit():position()))
			if dis < 300 then
				return true
			end
		end
	end
	return
end

LessHitMe_PlyM_dodge_chance = LessHitMe_PlyM_dodge_chance or PlayerManager.skill_dodge_chance

function PlayerManager:skill_dodge_chance(...)
	local chance = LessHitMe_PlyM_dodge_chance(self, ...)
	if self:is_less_targeted() then
		chance = chance + 0.15
	end
	return chance
end