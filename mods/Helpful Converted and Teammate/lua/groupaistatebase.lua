if Network:is_client() then
	return
end

_G.HelpfulConverted = _G.HelpfulConverted or {}

HelpfulConverted.Runner = nil

HelpfulConverted.Playing = HelpfulConverted.Playing or {}

Hooks:PostHook(GroupAIStateBase, "report_criminal_downed", "HelpfulConvertedreport_criminal_downed", function(gab, unit, ...)
	DelayedCalls:Add('DelayedMod_Help_'..tostring(unit:key()), 3, function()
		HelpfulConverted:Do_Help(unit)
	end)
end)

local HelpfulConverted_check_gameover_conditions = GroupAIStateBase.check_gameover_conditions

function GroupAIStateBase:check_gameover_conditions(...)
	local _gameover = HelpfulConverted_check_gameover_conditions(self, ...)
	--if _gameover and HelpfulConverted.Runner and alive(HelpfulConverted.Runner) then
	if _gameover then
		local _converted = HelpfulConverted:Get_Converted()
		if _converted then
			_gameover = false
		end
	end
	return _gameover
end

function HelpfulConverted:Get_Converted()
	local _all_enemies = managers.enemy:all_enemies() or {}
	local _converted = {}
	for _, data in pairs(_all_enemies) do
		if data and alive(data.unit) and data.unit:brain()._logic_data.is_converted then
			table.insert(_converted, data.unit)
		end
	end
	if not _converted or #_converted <= 0 then
		for _, data in pairs(managers.groupai:state():all_AI_criminals()) do
			if data and alive(data.unit) and data.status ~= "dead" then
				table.insert(_converted, data.unit)
			end
		end
	end
	if not _converted or #_converted <= 0 then
		return nil
	end
	local _ask_converted = nil
	local revive_SO_data = {
		unit = _need_help_unit
	}
	_ask_converted = _converted[math.random(#_converted)]
	if not _ask_converted or not alive(_ask_converted) then
		return nil
	end
	return _ask_converted
end

function HelpfulConverted:Check_Unit(r_unit)
	if r_unit:character_damage() then
		local damage_ext = r_unit:character_damage()
		if not damage_ext:dead() then
			if r_unit:interaction() then
				if r_unit:interaction():active() then
					return true
				end
			elseif r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested()) then
				return true
			end
		end
	end
	return false
end

function HelpfulConverted:Do_Help(unit)
	if (Network and Network:is_client()) or not unit or not alive(unit) then
		return
	end
	if not managers.groupai or not managers.groupai:state():all_criminals()[unit:key()] then
		return
	end
	local _need_help_unit = nil
	if self:Check_Unit(unit) then
		_need_help_unit = unit
	end
	if not _need_help_unit or not alive(_need_help_unit) then
		return
	end
	local _ask_converted = nil
	local revive_SO_data = {
		unit = _need_help_unit
	}
	_ask_converted = self:Get_Converted()
	if not _ask_converted or not alive(_ask_converted) then
		return
	end
	local objective_type, objective_action
	objective_type = "revive"
	objective_action = "revive"
	local Ready2Help = {
		nowtime = math.round(TimerManager:game():time()),
		rescuer = _ask_converted,
		revived = _need_help_unit
	}
	if not self:Is_Data_OK(Ready2Help) then
		return
	end
	local followup_objective = {
		scan = true,
		type = "act",
		action = {
			variant = "crouch",
			body_part = 1,
			type = "act",
			blocks = {
				heavy_hurt = -1,
				hurt = -1,
				action = -1,
				aim = -1,
				walk = -1
			}
		}
	}
	local objective = {
		type = "revive",
		called = true,
		scan = true,
		destroy_clbk_key = false,
		follow_unit = _need_help_unit,
		nav_seg = _need_help_unit:movement():nav_tracker():nav_segment(),
		pos = _need_help_unit:position(),
		fail_clbk = callback(self, self, "on_rescue_SO_failed", Ready2Help),
		complete_clbk = callback(self, self, "on_rescue_SO_completed", Ready2Help),
		action_start_clbk = callback(self, self, "on_rescue_SO_started", Ready2Help),
		action = {
			align_sync = true,
			type = "act",
			body_part = 1,
			variant = "revive",
			blocks = {
				light_hurt = -1,
				hurt = -1,
				action = -1,
				heavy_hurt = -1,
				aim = -1,
				walk = -1
			}
		},
		action_duration = tweak_data.interaction.revive.timer,
		followup_objective = followup_objective
	}
	_ask_converted:brain():set_objective(objective)
	DelayedCalls:Add('DelayedMod_Help_'..Idstring(tostring(_need_help_unit:key())):key(), tweak_data.interaction.revive.timer + 5, function()
		HelpfulConverted:Do_Help(_need_help_unit)
	end)
end

function HelpfulConverted:Is_Anyone_Need_Help()
	local _who = nil
	local _all_player_criminals = managers.groupai:state():all_player_criminals() or {}
	for u_key, u_data in pairs(_all_player_criminals) do
		if u_data.unit and alive(u_data.unit) and u_data.unit:character_damage() then
			if u_data.status == "bleedout" or u_data.status == "incapacitated" then
				_who = u_data.unit
				break
			end
		end
	end
	return _who
end

function HelpfulConverted:Is_Data_OK(data)
	if data and data.rescuer and data.revived and alive(data.rescuer) and alive(data.revived) and data.rescuer:character_damage() and data.revived:character_damage() then
		return true
	else
		return false
	end
end

function HelpfulConverted:on_rescue_SO_completed(data)
	if self:Is_Data_OK(data) and self:Check_Unit(data.revived) then
		local r_unit = data.revived
		if r_unit then
			if r_unit:interaction() then
				if r_unit:interaction():active() then
					r_unit:interaction():interact(r_unit)
				end
			elseif r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested()) then
				r_unit:character_damage():revive(r_unit)
			end
		end
	end
	self.Runner = nil
	self:Do_Help(self:Is_Anyone_Need_Help())
end

function HelpfulConverted:on_rescue_SO_failed(data)
	if self:Is_Data_OK(data) and data.revived:character_damage().unpause_downed_timer then
		data.revived:character_damage():unpause_downed_timer()
	end
	self.Runner = nil
	self:Do_Help(self:Is_Anyone_Need_Help())
end

function HelpfulConverted:on_rescue_SO_started(data)
	if self:Is_Data_OK(data) then
		if data.revived:character_damage()._downed_paused_counter then
			data.revived:character_damage():pause_downed_timer()
		end
		self.Runner = data.rescuer
		self.Playing[data.revived:key()] = data.rescuer
	end
end