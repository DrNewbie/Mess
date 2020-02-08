local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

for character, tweaks in pairs(tweak_data.character) do
	if type(tweaks) == "table" and tweaks.move_speed and character ~= "presets" then
		tweaks.hostage_move_speed = tweaks.surrender and tweaks.surrender ~= tweak_data.character.presets.surrender.special and tweak_data.character.civilian.hostage_move_speed or 1
	end
end

HuskCopBrain._ENABLE_LASER_TIME = 0.1
HuskCopBrain._NET_EVENTS.hostage_on = 3
HuskCopBrain._NET_EVENTS.hostage_off = 4

local fs_original_huskcopbrain_syncnetevent = HuskCopBrain.sync_net_event
function HuskCopBrain:sync_net_event(event_id)
	if event_id == self._NET_EVENTS.hostage_on then
		self._unit:movement().move_speed_multiplier = tweak_data.character[self._unit:base()._tweak_table].hostage_move_speed
	elseif event_id == self._NET_EVENTS.hostage_off then
		self._unit:movement().move_speed_multiplier = 1
	else
		fs_original_huskcopbrain_syncnetevent(self, event_id)
	end
end
