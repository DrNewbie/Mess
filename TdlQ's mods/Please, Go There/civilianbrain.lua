local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civilianbrain_onhostagefollowobjectivefailed = CivilianBrain.on_hostage_follow_objective_failed
function CivilianBrain:on_hostage_follow_objective_failed(unit)
	if unit then
		if unit:base().pgt_is_being_moved then
			unit:brain():on_pgt_state_changed(false)
		end
		unit:base().pgt_is_being_moved = nil
		unit:base().pgt_destination = nil
	end

	pgt_original_civilianbrain_onhostagefollowobjectivefailed(self, unit)
end

function CivilianBrain:on_pgt_state_changed(state)
	if state then
		if self._alert_listen_key then
			managers.groupai:state():remove_alert_listener(self._alert_listen_key)
		else
			self._alert_listen_key = 'CopBrain' .. tostring(self._unit:key())
		end
		local alert_listen_filter = managers.groupai:state():get_unit_type_filter('combatant')
		local alert_types = {
			bullet = true,
			vo_intimidate = true,
			aggression = true,
			explosion = true
		}
		managers.groupai:state():add_alert_listener(self._alert_listen_key, callback(self, self, 'on_alert'), alert_listen_filter, alert_types, self._unit:movement():m_head_pos())
	else
		self:on_cool_state_changed(false)
	end
end

function CivilianBrain:search_for_coarse_path(search_id, to_seg, verify_clbk, access_neg)
	local dst = self._unit:base().pgt_destination
	if dst then
		to_seg = managers.navigation:get_nav_seg_from_pos(dst, true) or to_seg
	end

	return CivilianBrain.super.search_for_coarse_path(self, search_id, to_seg, verify_clbk, access_neg)
end

function CivilianBrain:search_for_path(search_id, to_pos, prio, access_neg, nav_segs)
	local data = self._logic_data
	if data and type(data.pgt_nav_segs) == 'table' then
		nav_segs = data.pgt_nav_segs
		data.pgt_nav_segs = nil
	end

	return CivilianBrain.super.search_for_path(self, search_id, to_pos, prio, access_neg, nav_segs)
end
