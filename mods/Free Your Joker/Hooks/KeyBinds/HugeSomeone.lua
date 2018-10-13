local function JokerHugeSomeone_Run()
	local weapon_unit = managers.player:equipped_weapon_unit()
	if not weapon_unit or not alive(weapon_unit) then
		return
	end
	local ply_unit = managers.player:player_unit()
	if not ply_unit or not alive(ply_unit) then
		return
	end
	local PlyStandard = ply_unit:movement() and ply_unit:movement()._states.standard
	if not PlyStandard then
		return
	end
	local joker_list = managers.groupai:state():all_converted_enemies()
	if type(joker_list) ~= "table" then
		return
	end
	local cam_fwd = ply_unit:camera():forward()
	for i, joker_unit in pairs(joker_list) do
		if alive(joker_unit) and joker_unit:character_damage() then
			local boom_pos = joker_unit:movement():m_head_pos()
			local vec = boom_pos - ply_unit:position()
			local dis = mvector3.normalize(vec)
			local max_angle = math.max(8, math.lerp(10, 30, dis / 1200))
			local angle = vec:angle(cam_fwd)					
			if angle < max_angle or math.abs(max_angle-angle) < 10 then
				PlyStandard:_do_action_intimidate(TimerManager:game():time(), "cmd_gogo", "g18", true)
				joker_unit:character_damage():asked_to_huge()
				break
			end
		end
	end
end

JokerHugeSomeone_Run()