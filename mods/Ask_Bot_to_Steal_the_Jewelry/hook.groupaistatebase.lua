if not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "jewelry_store" then
	return
end

local AskBot2Stealth_Delay = 0
local AskBot2Stealth_NowTarget = nil
local AskBot2Stealth_unit_glass_now = nil

local DropZoon = Vector3(1418.96, 3047.95, 27)
local DropPlace = Vector3(1385.99, 3334.79, 37)

AskBot2StealthGetStandardSelf = AskBot2StealthGetStandardSelf or nil

AskBot2Stealth_Runner = AskBot2Stealth_Runner or nil

_G.CustomWaypoints = _G.CustomWaypoints or {}

_G.Keepers = _G.Keepers or {}

Hooks:PostHook(GroupAIStateBase, "update", "AskBot2StealthMain", function(self, t, dt)
	if not Global.game_settings or not Global.game_settings.level_id or Global.game_settings.level_id ~= "jewelry_store" then
		return
	end
	if not CustomWaypoints then
		return
	end
	if not Keepers then
		return
	end
	if not Monkeepers or Monkeepers.disabled then
		return
	end
	if not Utils:IsInGameState() or not Utils:IsInHeist() then
		return	
	end
	if not managers.groupai:state():whisper_mode() then
		return
	end
	if AskBot2Stealth_Delay > t then
		return
	end
	self.AskBot2Stealth_Action = self.AskBot2Stealth_Action or 0
	AskBot2Stealth_Delay = t + 0.5
	local PlyStandard = managers.player and managers.player:player_unit() and managers.player:player_unit():movement() and managers.player:player_unit():movement()._states.standard or nil
	if not PlyStandard then
		return
	end
	if managers.player:player_unit():movement()._current_state_name ~= 'standard' then
		return
	end
	local units = World:find_units_quick("all")
	local units_gen_pku_jewelry = {}
	for id, unit in pairs(units) do
		if unit and alive(unit) and unit:interaction() and unit:interaction():active() and unit:interaction().tweak_data and tweak_data.interaction[unit:interaction().tweak_data] then
			if Keepers:ValidInteraction(unit) and unit:interaction().tweak_data == 'gen_pku_jewelry' and mvector3.distance(unit:position(), Vector3(-447, -877, 77)) > 100 then
				table.insert(units_gen_pku_jewelry, unit)
			end
		end
		if unit and alive(unit) and unit:interaction() and not unit:interaction():active() and unit:interaction().tweak_data and tweak_data.interaction[unit:interaction().tweak_data] and unit:interaction().tweak_data == 'gen_pku_jewelry' and mvector3.distance(unit:position(), Vector3(-447, -877, 77)) > 100 then
			AskBot2Stealth_unit_glass_now = unit
		end
	end
	if not AskBot2Stealth_NowTarget or not alive(AskBot2Stealth_NowTarget) then
		for id, unit in pairs(units_gen_pku_jewelry) do
			AskBot2Stealth_NowTarget = unit
			self.AskBot2Stealth_Action = 1
			break
		end
	end
	if not AskBot2Stealth_Runner or not alive(AskBot2Stealth_Runner) then
		for u_key, u_data in pairs(self:all_AI_criminals()) do
			if u_data.unit and alive(u_data.unit) then
				AskBot2Stealth_Runner = u_data.unit
				break
			end
		end
		return
	end
	if not AskBot2Stealth_Runner or not alive(AskBot2Stealth_Runner) then
		AskBot2Stealth_Runner = nil
		return
	end
	if AskBot2Stealth_Runner:movement():cool() then
		AskBot2Stealth_Runner:movement():_switch_to_not_cool(true)
	end
	if AskBot2Stealth_Runner:movement():carrying_bag() then
		CustomWaypoints:PlaceMyWaypoint(DropZoon)
		PlyStandard:_start_action_intimidate_alt(t, true)
		AskBot2Stealth_Delay = t + 3
		if mvector3.distance(AskBot2Stealth_Runner:position(), DropZoon) < 100 then
			local carry_unit = AskBot2Stealth_Runner:movement()._carry_unit
			AskBot2Stealth_Runner:movement():set_carrying_bag(nil)
			carry_unit:carry_data():unlink()
			local dir = DropPlace - DropZoon
			mvector3.set_z(dir, math.abs(dir.x + dir.y) * 0.5)
			local throw_distance_multiplier = tweak_data.carry.types[tweak_data.carry[carry_unit:carry_data():carry_id()].type].throw_distance_multiplier
			carry_unit:push(tweak_data.ai_carry.throw_force, (dir - carry_unit:velocity()) * throw_distance_multiplier)
			self.AskBot2Stealth_Action = 0
			AskBot2Stealth_NowTarget = nil
		else
			self.AskBot2Stealth_Action = 6
			AskBot2Stealth_Delay = t + 2
			return
		end
	end
	if AskBot2Stealth_unit_glass_now and table.size(units_gen_pku_jewelry) < 1 then
		local BotPos = AskBot2Stealth_Runner:position()
		local GlassPos = AskBot2Stealth_unit_glass_now:position()
		if mvector3.distance(BotPos, GlassPos) < 150 then
			local col_ray = AskBot2Stealth_Runner:raycast("ray", BotPos, GlassPos, "ignore_unit", {managers.player:player_unit(), AskBot2Stealth_Runner}, "slot_mask", managers.slot:get_mask("bullet_impact_targets"), "sphere_cast_radius", 60, "ray_type", "body melee")
			if col_ray and col_ray.unit then
				managers.explosion:detect_and_give_dmg({
					player_damage = 0,
					hit_pos = GlassPos,
					range = 200,
					collision_slotmask = managers.slot:get_mask("explosion_targets"),
					curve_pow = 1,
					damage = 1,
					ignore_unit = {managers.player:player_unit(), AskBot2Stealth_Runner},
					alert_radius = 1,
					user = managers.player:player_unit(),
					owner = managers.player:player_unit()
				})
				local state = AskBot2Stealth_Runner:movement():play_redirect("melee")
				if state then
					local anim_speed = 1
					AskBot2Stealth_Runner:anim_state_machine():set_speed(state, anim_speed)
				end
				if AskBot2Stealth_unit_glass_now:interaction() and AskBot2Stealth_unit_glass_now:interaction():active() then
					AskBot2Stealth_unit_glass_now = nil
				end
			end
		else
			if not AskBot2Stealth_Runner:movement():carrying_bag() then
				CustomWaypoints:PlaceMyWaypoint(AskBot2Stealth_unit_glass_now:position())
				PlyStandard:_start_action_intimidate_alt(t, true)
				AskBot2Stealth_Delay = t + 1
			end
		end
		return
	end
	if not AskBot2Stealth_Runner:movement():carrying_bag() then
		if not AskBot2Stealth_NowTarget or not alive(AskBot2Stealth_NowTarget) then
			AskBot2Stealth_NowTarget = nil
			return
		end
	end
	if self.AskBot2Stealth_Action == 1 then
		self.AskBot2Stealth_Action = 2
		AskBot2Stealth_Delay = t + 1
		return
	end
	if self.AskBot2Stealth_Action == 2 then
		self.AskBot2Stealth_Action = 3
		if not AskBot2Stealth_Runner:movement():carrying_bag() then
			CustomWaypoints:PlaceMyWaypoint(AskBot2Stealth_NowTarget:position())
		end
		return
	end
	if self.AskBot2Stealth_Action == 3 then
		self.AskBot2Stealth_Action = 4
		Keepers:GetWaypointSO(AskBot2Stealth_Runner, 1)
		return
	end
	if self.AskBot2Stealth_Action == 4 then
		self.AskBot2Stealth_Action = 5
		PlayerStandard.mpk_add_ai_teammates_cool = true
		PlayerStandard.add_minions_to_teammates = true
		PlyStandard:_start_action_intimidate_alt(t, true)
		AskBot2Stealth_Delay = t + 5
		return
	end
end)