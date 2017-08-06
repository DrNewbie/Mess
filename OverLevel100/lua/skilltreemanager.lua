local _f_SkillTreeManager_verify_loaded_data = SkillTreeManager._verify_loaded_data

function SkillTreeManager:_verify_loaded_data(points_aquired_during_load)
	local level_points = managers.experience:current_level()
	if level_points > 100 then
		local assumed_points = level_points + points_aquired_during_load
		if assumed_points > 120 then
			points_aquired_during_load = -(assumed_points - 120 - points_aquired_during_load)
		end
	end
	_f_SkillTreeManager_verify_loaded_data(self, points_aquired_during_load)
end

function SkillTreeManager:level_up()
	if managers.experience:current_level() > 100 then
		return		
	end
	self:_aquire_points(1)
end