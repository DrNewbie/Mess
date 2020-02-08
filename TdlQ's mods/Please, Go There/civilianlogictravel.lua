local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civilianlogictravel_enter = CivilianLogicTravel.enter
function CivilianLogicTravel.enter(data, new_logic_name, enter_params)
	local old_data = data.internal_data
	pgt_original_civilianlogictravel_enter(data, new_logic_name, enter_params)
	local my_data = data.internal_data
	my_data.rebellion_meter = old_data.rebellion_meter
	my_data.check_surroundings_t = old_data.check_surroundings_t
end

local pgt_original_civilianlogictravel_determineexactdestination = CivilianLogicTravel._determine_exact_destination
function CivilianLogicTravel._determine_exact_destination(data, objective)
	return data.unit:base().pgt_destination or pgt_original_civilianlogictravel_determineexactdestination(data, objective)
end

local pgt_original_civilianlogictravel_onalert = CivilianLogicTravel.on_alert
function CivilianLogicTravel.on_alert(data, alert_data)
	if data.unit:base().pgt_is_being_moved then
		CivilianLogicSurrender.pgt_on_alert(data, alert_data)
	else
		pgt_original_civilianlogictravel_onalert(data, alert_data)
	end
end

local pgt_original_civilianlogictravel_update = CivilianLogicTravel.update
function CivilianLogicTravel.update(data)
	local my_data = data.internal_data
	local ub = data.unit:base()
	if ub.pgt_destination and my_data.coarse_path and my_data.coarse_path_index >= #my_data.coarse_path then
		data.brain:on_hostage_move_interaction(nil, 'stay')
		return
	end

	if not ub.pgt_destination and not my_data.has_old_action and ub.pgt_is_being_moved and my_data.advancing then
		if Iter.settings.streamline_path then
			CopLogicTravel._chk_stop_for_follow_unit(data, my_data)
			if my_data ~= data.internal_data then
				return
			end
		end
	end

	pgt_original_civilianlogictravel_update(data)
end
