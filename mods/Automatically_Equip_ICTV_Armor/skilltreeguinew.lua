Hooks:PostHook(NewSkillTreeGui, "invest_point", "J_"..Idstring("Automatically Equip ICTV Armor"):key(), function(self, item)
	local skill_id = item:skill_id()
	local step = self._skilltree:next_skill_step(skill_id)
	local unlocked = self._skilltree:skill_unlocked(nil, skill_id)
	local completed = self._skilltree:skill_completed(skill_id)
	local skill_data = tweak_data.skilltree.skills[skill_id]
	if completed and unlocked and skill_id == "juggernaut" then
		managers.blackmarket:equip_armor("level_7")
		managers.blackmarket:release_preloaded_category("armor_skin")
	end
end)