local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local gcw_original_hudmanager_save = HUDManager.save
function HUDManager:save(data)
	gcw_original_hudmanager_save(self, data)

	local remove_list = {}
	for id, _ in pairs(data.HUDManager.waypoints) do
		if type(id) == 'string' and id:find(CustomWaypoints.prefix) == 1 then
			remove_list[id] = true
		end
	end

	for id in pairs(remove_list) do
		data.HUDManager.waypoints[id] = nil
	end
end

local function gcw_set_visibility(data)
	local offscreen = data.state == 'offscreen'
	if offscreen ~= data.arrow:visible() then
	elseif offscreen then
		data.arrow:set_visible(false)
		data.bitmap:set_visible(false)
	else
		data.bitmap:set_visible(true)
	end
end

local _settings = CustomWaypoints.settings
local _prefix = CustomWaypoints.prefix
local _prefix_local = _prefix .. 'localplayer'

local gcw_original_hudmanager_updatewaypoints = HUDManager._update_waypoints
function HUDManager:_update_waypoints(t, dt)
	gcw_original_hudmanager_updatewaypoints(self, t, dt)

	local always_show_my_waypoint = _settings.always_show_my_waypoint
	local always_show_others_waypoints = _settings.always_show_others_waypoints
	if not always_show_my_waypoint or not always_show_others_waypoints then
		for id, data in pairs(self._hud.waypoints) do
			if id == _prefix_local then
				if not always_show_my_waypoint then
					gcw_set_visibility(data)
				end
			elseif type(id) == 'string' and id:find(_prefix) == 1 then
				if not always_show_others_waypoints then
					gcw_set_visibility(data)
				end
			end
		end
	end
end

function HUDManager:gcw_get_custom_waypoint_by_peer(peer_id)
	local mine
	if peer_id then
		local local_peer_id = managers.network:session():local_peer():id()
		mine = peer_id == local_peer_id
	else
		mine = true
	end

	local waypoint = self._hud and self._hud.waypoints[_prefix .. (mine and 'localplayer' or peer_id)]
	if not waypoint then
		return
	end

	return waypoint.position, waypoint.unit
end

function HUDManager:gcw_get_my_custom_waypoint()
	return self:gcw_get_custom_waypoint_by_peer()
end

function HUDManager:gcw_remove_attached_waypoints(unit)
	local to_remove = {}
	for id, data in pairs(self._hud.waypoints) do
		if data.unit == unit then
			to_remove[id] = true
		end
	end
	for id in pairs(to_remove) do
		managers.hud:remove_waypoint(id)
	end
end

if Global.game_settings and Global.game_settings.level_id == 'big' then
	local gcw_original_hudmanager_addwaypoint = HUDManager.add_waypoint
	function HUDManager:add_waypoint(id, data)
		if id == 104665 then
			CustomWaypoints.interactive_units_white_list[Idstring('units/payday2/equipment/gen_interactable_hack_computer_pear/gen_interactable_hack_computer_pear_keyboard'):t()] = false
		end

		return gcw_original_hudmanager_addwaypoint(self, id, data)
	end
end
