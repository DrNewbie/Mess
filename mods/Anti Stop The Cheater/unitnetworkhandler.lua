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
		if not RecordTime[sender] or (RecordTime[sender] and RecordTime[sender].user_id ~= _uid) then
			RecordTime[sender] = {
				user_id = _uid,
				sustain = math.abs(sustain)
			}
		else
			RecordTime[sender].sustain = RecordTime[sender].sustain + math.abs(sustain)
		end
		if RecordTime[sender].sustain > 15 then
			local peer_name = tostring(peer_sender:name())
			managers.chat:feed_system_message(ChatManager.GAME, "[!!] {"..peer_name.."(".._uid..")} is sending some")
			managers.chat:feed_system_message(ChatManager.GAME, "timespeed effect to you.")
			managers.chat:feed_system_message(ChatManager.GAME, "Total:{"..RecordTime[sender].sustain.."}")
			if RecordTime[sender].sustain > 120 then
				managers.chat:feed_system_message(ChatManager.GAME, "[!!] {"..peer_name.."} send too much timespeed effect to you.")
				peer_sender:send("start_timespeed_effect", "pause", "pausable", "player;game;game_animation", 0.05, 1, 3600, 1)
			end
			return
		end
	end
	Check_start_timespeed_effect(self, effect_id, timer_name, affect_timer_names_str, speed, fade_in, sustain, fade_out, sender)
end