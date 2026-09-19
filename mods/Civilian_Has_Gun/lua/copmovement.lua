local hook1 = "F_"..Idstring("hook1::"..tostring(_G["CivilianHasGun"])):key()
local bool1 = "F_"..Idstring("bool1::"..tostring(_G["CivilianHasGun"])):key()

Hooks:PostHook(CopMovement, "update", "F2_"..Idstring(tostring(_G["CivilianHasGun"])):key(), function(self)
	if managers.groupai and self._ext_inventory and self._ext_inventory:equipped_unit() and self:can_request_actions() and not self._pre_destroyed and self._unit:base()[bool1] and not self:cool() then
		self._unit:base()[bool1] = false
		local gro = managers.groupai:state()
		local team_id = tweak_data.levels:get_default_team_ID("combatant")
		self:set_team(gro:team_data(team_id))
		gro:assign_enemy_to_group_ai(self._unit, team_id)
	end
end)