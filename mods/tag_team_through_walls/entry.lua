local function __check_and_run(__them, __player, __criminals)
	local tagged = nil
	if __player and not table.empty(__criminals) then
		local player_eye = __player:camera():position()
		local player_fwd = __player:camera():rotation():y()
		local tag_distance = managers.player:upgrade_value("player", "tag_team_base").distance * 100			
		for u_key, u_data in pairs(__criminals) do
			local unit = nil
			if type(u_data.unit) == "userdata" then
				unit = u_data.unit
			elseif type(u_data) == "userdata" then
				unit = u_data
			end
			if type(unit) == "userdata" and alive(unit) and unit:position() then
				if mvector3.distance_sq(player_eye, unit:position()) < tag_distance * tag_distance then
					local cam_fwd = player_fwd
					local vec = unit:position() - player_eye
					local dis = mvector3.normalize(vec)
					local max_angle = math.max(8, math.lerp(10, 30, dis / 1200))
					local angle = vec:angle(cam_fwd)
					if angle < max_angle or math.abs(max_angle - angle) < 10 then
						tagged = unit
						break
					end				
				end
			end
		end
		if tagged and not __them._coroutine_mgr:is_running("tag_team") then
			__them:add_coroutine("tag_team", PlayerAction.TagTeam, tagged, __player)
			return true
		end			
	end
	return false
end

Hooks:PostHook(PlayerManager, "_attempt_tag_team", "Tag Team Through Walls", function(self, ...)
	local ans = Hooks:GetReturn()
	if not ans and not self._coroutine_mgr:is_running("tag_team") then
		local player = managers.player:player_unit()
		local all_criminals = managers.groupai:state():all_criminals()
		local all_converted_enemies = managers.groupai:state():all_converted_enemies()
		if __check_and_run(self, player, all_criminals) then
			return true
		elseif __check_and_run(self, player, all_converted_enemies) then
			return true
		end
	end
	return ans
end)