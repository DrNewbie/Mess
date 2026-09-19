local RecordTime = RecordTime or {}

local Check_start_timespeed_effect = UnitNetworkHandler.start_timespeed_effect

function UnitNetworkHandler:start_timespeed_effect(effect_id, timer_name, affect_timer_names_str, speed, fade_in, sustain, fade_out, sender)
	local peer_sender = self._verify_sender(sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not peer_sender then
		return
	end
	effect_id = tostring(effect_id)
	affect_timer_names_str = tostring(affect_timer_names_str)
	if effect_id:find("pause") and (affect_timer_names_str:find("game_animation") or affect_timer_names_str:find("game") or affect_timer_names_str:find("player")) then
		local _uid = tostring(peer_sender:user_id())
		local abs_sustain = math.abs(sustain)
		local abs_speed = math.abs(speed)
		if abs_speed < 0.2 then
			speed = 0.2
		end
		if not RecordTime[sender] or (RecordTime[sender] and RecordTime[sender].user_id ~= _uid) then
			RecordTime[sender] = {
				user_id = _uid,
				sustain = abs_sustain,
				try = 0
			}
		else
			RecordTime[sender].sustain = RecordTime[sender].sustain + abs_sustain
		end
		local peer_name = tostring(peer_sender:name())
		if abs_sustain > 0 then
			managers.chat:feed_system_message(ChatManager.GAME, "[!!] {"..peer_name.."(".._uid..")} is sending some")
			managers.chat:feed_system_message(ChatManager.GAME, "timespeed effect to you.")
			managers.chat:feed_system_message(ChatManager.GAME, "Ask:{"..abs_sustain.."}")
			managers.chat:feed_system_message(ChatManager.GAME, "Total:{"..RecordTime[sender].sustain.."}")
			if RecordTime[sender].sustain > 15 or abs_sustain > 7 then
				if RecordTime[sender].sustain > 120 and RecordTime[sender].try < 5 then
					managers.chat:feed_system_message(ChatManager.GAME, "[!!] {"..peer_name.."} send too much timespeed effect to you.")
					RecordTime[sender].try = RecordTime[sender].try + 1
					peer_sender:send("start_timespeed_effect", "pause", "pausable", "player;game;game_animation", 0.05, 1, 3600, 1)
				end
				return
			end
		end
	end
	Check_start_timespeed_effect(self, effect_id, timer_name, affect_timer_names_str, speed, fade_in, sustain, fade_out, sender)
end