_G.OVK_Keepers = _G.OVK_Keepers or {}

if Network:is_client() then
	return
end

if not OVK_Keepers then
	return
end

if OVK_Keepers.settings.no_driving_so_move ~= 1 then
	return
end

function PlayerDriving:enter(state_data, enter_data)
	print("PlayerDriving:enter( enter_data )")
	PlayerDriving.super.enter(self, state_data, enter_data)
	if OVK_Keepers.settings.no_driving_so_move == 1 then
		return
	end
	for _, ai in pairs(managers.groupai:state():all_AI_criminals()) do
		if ai.unit:movement() and ai.unit:movement()._should_stay then
			ai.unit:movement():set_should_stay(false)
		end
	end
end