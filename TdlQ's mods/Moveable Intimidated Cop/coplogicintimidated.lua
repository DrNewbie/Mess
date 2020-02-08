local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mic_original_coplogicintimidated_enter = CopLogicIntimidated.enter
function CopLogicIntimidated.enter(data, new_logic_name, enter_params)
	data.original_brain_SO_access = data.original_brain_SO_access or data.brain._SO_access
	data.original_SO_access = data.original_SO_access or data.SO_access
	data.original_SO_access_str = data.original_SO_access_str or data.SO_access_str
	data.original_char_tweak = data.original_char_tweak or data.char_tweak

	data.brain._SO_access = data.original_brain_SO_access
	data.SO_access = data.original_SO_access
	data.SO_access_str = data.original_SO_access_str
	managers.groupai:state()._police[data.key].so_access = data.SO_access
	data.char_tweak = data.original_char_tweak

	mic_original_coplogicintimidated_enter(data, new_logic_name, enter_params)

	if data.mic_is_being_moved then
		data.unit:base():set_slot(data.unit, 22)
		data.internal_data.tied = true
		data.important = false
		data.brain:on_mic_state_changed(false)
	end
end

local mic_original_coplogicintimidated_exit = CopLogicIntimidated.exit
function CopLogicIntimidated.exit(data, new_logic_name, enter_params)
	local old_is_hostage = data.internal_data.is_hostage
	if data.mic_is_being_moved then
		data.internal_data.is_hostage = false
	end

	mic_original_coplogicintimidated_exit(data, new_logic_name, enter_params)
	data.internal_data.is_hostage = old_is_hostage

	if data.mic_is_being_moved then
		data.internal_data.state_enter_t = TimerManager:game():time()
		data.unit:base():set_slot(data.unit, 22)
		data.important = true
		data.unit:body('mover_blocker'):set_enabled(false)
		data.SO_access_str = tweak_data.character.civilian.access
		data.SO_access = managers.navigation:convert_access_flag(data.SO_access_str)
		data.brain._SO_access = data.SO_access
		data.char_tweak = deep_clone(tweak_data.character.civilian)
		data.char_tweak.weapon = data.original_char_tweak.weapon
		managers.groupai:state()._police[data.key].so_access = data.SO_access
		data.brain:on_mic_state_changed(true)
		data.internal_data.check_surroundings_t = 0
		data.internal_data.rebellion_meter = 0
		data.is_suppressed = nil
	elseif not (data.brain._logic_data.is_converted or data.unit:character_damage():dead()) then
		local bmb = data.unit:body('mover_blocker')
		if bmb then
			bmb:set_enabled(true)
		end
	end
end

function CopLogicIntimidated.on_new_objective(data, old_objective)
	CopLogicBase.on_new_objective(data, old_objective)

	if data.mic_is_being_moved then
		local new_objective = data.objective
		local my_data = data.internal_data
		if new_objective then
			if CopLogicIdle._chk_objective_needs_travel(data, new_objective) then
				CopLogicBase._exit(data.unit, 'travel')
			elseif objective_type == 'surrender' then
				CopLogicBase._exit(data.unit, 'intimidated', new_objective.params)
			end
		elseif not my_data.exiting then
			CopLogicBase._exit(data.unit, 'idle')
		end
	end
end

local mic_original_coplogicintimidated_updateenemydetection = CopLogicIntimidated._update_enemy_detection
function CopLogicIntimidated._update_enemy_detection(data, my_data)
	if data.mic_is_being_moved then
		my_data.tied = true
	end
	mic_original_coplogicintimidated_updateenemydetection(data, my_data)
end

local mic_original_coplogicintimidated_update = CopLogicIntimidated.update
function CopLogicIntimidated.update(data)
	if not data.mic_is_being_moved then
		mic_original_coplogicintimidated_update(data)
	end
end

local mic_original_coplogicintimidated_dotied = CopLogicIntimidated._do_tied
function CopLogicIntimidated._do_tied(data, aggressor_unit)
	data.is_tied = true

	mic_original_coplogicintimidated_dotied(data, aggressor_unit)

	if not managers.groupai:state():whisper_mode() then
		data.unit:interaction():set_tweak_data('hostage_convert')
		data.unit:interaction():set_active(true, true, false)
	end
end
