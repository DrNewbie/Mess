local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local kic_original_civilianlogicinactive_setinteraction = CivilianLogicInactive._set_interaction
function CivilianLogicInactive._set_interaction(data, my_data)
	if data.unit:character_damage():dead() and managers.groupai:state():whisper_mode() then
		if math.random() < KeepItClean.cops_in_disguise_chance[KeepItClean.settings.cops_in_disguise] then
			data.unit:unit_data().has_alarm_pager = true
			data.brain:begin_alarm_pager()
			return
		end
	end

	kic_original_civilianlogicinactive_setinteraction(data, my_data)
end
