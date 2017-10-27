if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "run" then
	return
end

local DedMatt_Hurt = 15
local DedMatt_Hurt_Range = 500

--[[
if Global.game_settings.difficulty == "normal" then
	DedMatt_Hurt = 27
elseif Global.game_settings.difficulty == "hard" then
	DedMatt_Hurt = 25
elseif Global.game_settings.difficulty == "overkill" then
	DedMatt_Hurt = 25
elseif Global.game_settings.difficulty == "overkill_145" then
	DedMatt_Hurt = 25
elseif Global.game_settings.difficulty == "easy_wish" then
	DedMatt_Hurt = 20
elseif Global.game_settings.difficulty == "overkill_290" then
	DedMatt_Hurt = 20
elseif Global.game_settings.difficulty == "sm_wish" then
	DedMatt_Hurt = 10
end
]]

Hooks:PostHook(GroupAIStateBase, "init", "DedMatt_init", function(self)
	self._DedMatt_Run = 0
	self._DedMatt_Unit = nil
	self._DedMatt_Delay = 0
	self._DedMatt_Attacker = -1
end)

function GroupAIStateBase:DedMatt_RunMain(unit)
	self._DedMatt_Unit = unit
	self._DedMatt_Run = 1
	self._DedMatt_Delay = -1
	self._DedMatt_WP = false
end

function GroupAIStateBase:Get_DedMatt()
	return self._DedMatt_Unit
end

function GroupAIStateBase:Hurt_DedMatt(damage)
	if not self._DedMatt_Unit or not alive(self._DedMatt_Unit) or self._DedMatt_Unit:character_damage():dead() then
		return
	end
	damage = damage or 1
	self._DedMatt_Unit:character_damage():damage_mission({
		damage = damage,
		forced = true
	})
end

Hooks:PostHook(GroupAIStateBase, "update", "DedMatt_update", function(self, t)
	if not self._DedMatt_Unit or not alive(self._DedMatt_Unit) or self._DedMatt_Unit:character_damage():dead() then
		if self._DedMatt_Run == 1 then
			self._DedMatt_Run = 2
			--Matt is dead, GG
			managers.hud:remove_waypoint('DedMattUnderAttack')
			managers.chat:send_message(ChatManager.GAME, "", "[System]: Matt is dead, Game Over.")
			DelayedCalls:Add('MattDeadGG', 5, function()
				managers.network:session():send_to_peers("mission_ended", false, 0)
				game_state_machine:change_state_by_name("gameoverscreen")
			end)
			managers.hud:add_waypoint(
				'DedMattUnderAttack', {
				icon = 'pd2_kill',
				distance = true,
				position = self._DedMatt_Unit:position(),
				no_sync = true,
				present_timer = 0,
				state = "present",
				radius = 50,
				color = Color.green,
				blend_mode = "add"
			})
		end
		return
	end
	if self._DedMatt_Delay == -1 then
		self._DedMatt_Delay = t + 20
		return
	end
	if self._DedMatt_Delay > t then
		return
	end
	self._DedMatt_Delay = t + 1
	local _under_attack = false
	local _units = World:find_units("sphere", self._DedMatt_Unit:position(), DedMatt_Hurt_Range, managers.slot:get_mask("enemies"), "ignore_unit", self._DedMatt_Unit) or {}
	for u_key, u_data in pairs(_units) do
		if u_data and alive(u_data) and u_data ~= self._DedMatt_Unit and managers.enemy:is_enemy(u_data) then 
			_under_attack = true
			self._DedMatt_WP = true
			managers.hud:add_waypoint(
				'DedMattUnderAttack', {
				icon = 'pd2_generic_interact',
				distance = true,
				position = self._DedMatt_Unit:position(),
				no_sync = true,
				present_timer = 0,
				state = "present",
				radius = 50,
				color = Color.green,
				blend_mode = "add"
			})
			if self._DedMatt_Attacker == -1 then
				self._DedMatt_Attacker = t + DedMatt_Hurt
			elseif self._DedMatt_Attacker > 0 and t > self._DedMatt_Attacker then
				self._DedMatt_Attacker = -1
				self._DedMatt_Delay = t + DedMatt_Hurt + 1
				self:Hurt_DedMatt()
			end
			break			
		end
	end
	if not _under_attack then
		self._DedMatt_Attacker = -1
		if self._DedMatt_WP then
			self._DedMatt_WP = false
			managers.hud:remove_waypoint('DedMattUnderAttack')
		end
	else
	
	end
end)