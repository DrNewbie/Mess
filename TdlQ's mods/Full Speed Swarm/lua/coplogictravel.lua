local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_settings = FullSpeedSwarm.final_settings

local mvec3_dis_sq = mvector3.distance_sq
function CopLogicTravel._try_anounce(data, my_data)
	local my_pos = data.m_pos
	local max_dis_sq = 250000
	local my_key = data.key
	local announce_type = data.char_tweak.announce_incomming
	local tdc = tweak_data.character
	for u_key, u_data in pairs(managers.enemy:all_enemy_announcers()) do
		if u_key ~= my_key then
			if tdc[u_data.tweak_table].chatter[announce_type] then
				local unit = u_data.unit
				if max_dis_sq > mvec3_dis_sq(my_pos, u_data.m_pos) and not unit:sound():speaking(data.t) and (unit:anim_data().idle or unit:anim_data().move) then
					managers.groupai:state():chk_say_enemy_chatter(unit, u_data.m_pos, announce_type)
					my_data.announce_t = data.t + 15
				end
			end
		end
	end
end

function CopLogicTravel.queue_update(data, my_data, delay)
	if data.important or fs_settings.fastpaced then
		delay = 0.1
	else
		delay = delay or 0.3
	end
	CopLogicBase.queue_task(my_data, my_data.upd_task_key, CopLogicTravel.queued_update, data, data.t + delay, data.important and true)
end

function CopLogicTravel.queued_update(data)
	local delay
	local my_data = data.internal_data
	my_data.close_to_criminal = nil
	local t = TimerManager:game():time()
	data.t = t

	if fs_settings.fastpaced then
		local next_detection_t = data.fs_next_detection_t or 0
		if t >= next_detection_t then
			delay = CopLogicTravel._upd_enemy_detection(data)
			data.fs_next_detection_t = t + delay
		end
	else
		delay = CopLogicTravel._upd_enemy_detection(data)
	end

	if data.internal_data ~= my_data then
		return
	end

	CopLogicTravel.upd_advance(data)

	if data.internal_data ~= my_data then
		return
	end

	CopLogicTravel.queue_update(data, data.internal_data, delay)
end
