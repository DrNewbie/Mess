NewSkillTreeSkillItem.NewSkillDescBecauseTraining = NewSkillTreeSkillItem.NewSkillDescBecauseTraining or {}

Hooks:PostHook(NewSkillTreeSkillItem, "init", "RunNewSkillDescBecauseTraining", function(self)
	for skill_id, skill_data in pairs(tweak_data.skilltree.skills) do
		if type(skill_data) == "table" and type(skill_data.name_id) == "string" and type(skill_data.desc_id) == "string" and not self.NewSkillDescBecauseTraining[skill_data.desc_id] then
			self.NewSkillDescBecauseTraining[skill_data.desc_id] = true
			local old_desc = managers.localization:text(skill_data.desc_id)
			local new_desc = ""
			local __new_line = {}
			local __next_fix = false
			for __line in old_desc:gmatch("([^\n]*)\n?") do
				__line = tostring(__line)
				if __line:find("##$pro;##") then
					__next_fix = true
					if skill_data.name_id ~= 'martial_arts' then
						__new_line[#__new_line-1] = __new_line[#__new_line-1].." Because of training."
					end
				else
					if __next_fix then
						__next_fix = false
						__line = "Because of training. "..__line
					end
				end
				__new_line[#__new_line+1] = __line
			end
			LocalizationManager:add_localized_strings({
				[skill_data.desc_id] = table.concat(__new_line, '\n')
			})
		end
	end
end)