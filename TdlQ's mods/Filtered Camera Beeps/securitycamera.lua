local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Network:is_server() then
	return
end

local fcb_original_securitycamera_init = SecurityCamera.init
function SecurityCamera:init(...)
	self.fcb_suspicion_levels = {0, 0, 0, 0}
	self.fcb_suspicion_levels_sync = {0, 0, 0, 0}
	return fcb_original_securitycamera_init(self, ...)
end

local fcb_original_securitycamera_save = SecurityCamera.save
function SecurityCamera:save(data)
	fcb_original_securitycamera_save(self, data)
	data.suspicion_lvl = nil
end

local REACT_SCARED = AIAttentionObject.REACT_SCARED
function SecurityCamera:_upd_sound(unit, t)
	if self._alarm_sound then
		return
	end

	local new_suspicion_levels = {}
	for u_key, attention_info in pairs(self._detected_attention_objects) do
		local progress
		if attention_info.reaction >= REACT_SCARED then
			if attention_info.identified then
				self:_sound_the_alarm(attention_info.unit)
				return
			end
			progress = attention_info.notice_progress
		else
			progress = attention_info.uncover_progress
		end

		local peer
		if attention_info.is_human_player then
			peer = managers.network:session():peer_by_unit(attention_info.unit)
		elseif attention_info.is_person then
			local brain = attention_info.unit:brain()
			if brain and brain.objective then
				local objective = brain:objective()
				if objective and objective.type == 'follow' then
					peer = managers.network:session():peer_by_unit(objective.follow_unit)
				end
			end
		elseif attention_info.is_deployable then
			local owner_id = attention_info.unit:base()._owner_id
			if owner_id then
				peer = managers.network:session():peer(owner_id)
			end
		else
			local cd = attention_info.unit:carry_data()
			if cd then
				peer = managers.network:session():peer(cd:latest_peer_id())
			end
		end

		if peer then
			local peer_id = peer:id()
			local suspicion_level = new_suspicion_levels[peer_id]
			if not suspicion_level or progress > suspicion_level then
				new_suspicion_levels[peer_id] = progress
			end
		end
	end

	for i = 1, 4 do
		local new_suspicion_level = new_suspicion_levels[i]
		if new_suspicion_level then
			self:_set_suspicion_sound(new_suspicion_level, i)
		elseif self.fcb_suspicion_levels_sync[i] > 0 then
			self:_stop_all_sounds(i)
		end
	end
end

function SecurityCamera:_set_suspicion_sound(suspicion_level, peer_id)
	if peer_id == 1 then
		if self.fcb_suspicion_levels[peer_id] == suspicion_level then
			return
		end
		if not self._suspicion_sound then
			self._suspicion_sound = self._unit:sound_source():post_event('camera_suspicious_signal')
			self.fcb_suspicion_levels[peer_id] = 0
		end
		local pitch = suspicion_level >= self.fcb_suspicion_levels[peer_id] and 1 or 0.6
		self.fcb_suspicion_levels[peer_id] = suspicion_level
		self.fcb_suspicion_levels_sync[peer_id] = math.clamp(math.ceil(suspicion_level * 6), 1, 6)
		self._unit:sound_source():set_rtpc('camera_suspicion_level_pitch', pitch)
		self._unit:sound_source():set_rtpc('camera_suspicion_level', suspicion_level)

	else
		local suspicion_lvl_sync = math.clamp(math.ceil(suspicion_level * 6), 1, 6)
		if suspicion_lvl_sync ~= self.fcb_suspicion_levels_sync[peer_id] then
			local event_id = self._NET_EVENTS['suspicion_' .. tostring(suspicion_lvl_sync)]
			if self:_send_net_event(event_id, peer_id) then
				self.fcb_suspicion_levels_sync[peer_id] = suspicion_lvl_sync
			end
		end
	end
end

function SecurityCamera:_stop_all_sounds(peer_id)
	if peer_id == 1 then
		self._alarm_sound = nil
		self._suspicion_sound = nil
		self._unit:sound_source():post_event('camera_silent')
		self.fcb_suspicion_levels[peer_id] = 0
		self.fcb_suspicion_levels_sync[peer_id] = 0

	elseif peer_id then
		if self.fcb_suspicion_levels_sync[peer_id] > 0 then
			self:_send_net_event(self._NET_EVENTS.sound_off, peer_id)
		end
		self.fcb_suspicion_levels[peer_id] = 0
		self.fcb_suspicion_levels_sync[peer_id] = 0

	else
		self._alarm_sound = nil
		self._suspicion_sound = nil
		self.fcb_suspicion_levels = {0, 0, 0, 0}
		self:_send_net_event(self._NET_EVENTS.sound_off)
		self._unit:sound_source():post_event('camera_silent')
	end
end

function SecurityCamera:_send_net_event(event_id, peer_id)
	if not peer_id then
		managers.network:session():send_to_peers_synched('sync_unit_event_id_16', self._unit, 'base', event_id)
	elseif peer_id ~= 1 then
		local session = managers.network:session()
		local peer = session:peer(peer_id)
		if peer then
			session:send_to_peer_synched(peer, 'sync_unit_event_id_16', self._unit, 'base', event_id)
			return peer:synched()
		end
	end
end
