local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not FullSpeedSwarm then
	for character, tweaks in pairs(tweak_data.character) do
		if type(tweaks) == 'table' and tweaks.move_speed and character ~= 'presets' then
			tweaks.hostage_move_speed = tweaks.surrender and tweaks.surrender ~= tweak_data.character.presets.surrender.special and tweak_data.character.civilian.hostage_move_speed or 1
		end
	end

	local hostages = {}

	HuskCopBrain._NET_EVENTS.hostage_on = 3
	HuskCopBrain._NET_EVENTS.hostage_off = 4

	local mic_original_huskcopbrain_syncnetevent = HuskCopBrain.sync_net_event
	function HuskCopBrain:sync_net_event(event_id)
		if event_id == self._NET_EVENTS.hostage_on then
			hostages[self._unit:key()] = self._unit
		elseif event_id == self._NET_EVENTS.hostage_off then
			hostages[self._unit:key()] = nil
		else
			mic_original_huskcopbrain_syncnetevent(self, event_id)
		end
	end

	function HuskCopBrain:is_hostage()
		return hostages[self._unit:key()] ~= nil
	end
end
