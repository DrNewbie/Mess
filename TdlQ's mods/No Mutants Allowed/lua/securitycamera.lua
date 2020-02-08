local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local nma_original_securitycamera_requeststarttapeloopbyupgradelevel = SecurityCamera._request_start_tape_loop_by_upgrade_level
function SecurityCamera:_request_start_tape_loop_by_upgrade_level(time_upgrade_level)
	nma_original_securitycamera_requeststarttapeloopbyupgradelevel(self, time_upgrade_level)

	if time_upgrade_level > 0 then
		NoMA:CheckUpgrade(peer, 'player_tape_loop_duration_' .. tostring(time_upgrade_level))
	end
end
