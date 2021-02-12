if not Global.game_settings or not Global.game_settings.level_id or tostring(Global.game_settings.level_id) ~= "cage" then

else
	local mod_ids = Idstring("[Car Shop] Add zipline between start and end"):key()

	local zipline_motor_alt_ids = Idstring("units/payday2/equipment/gen_equipment_zipline_motor_alt/gen_equipment_zipline_motor_alt")

	Hooks:PostHook(DialogManager, "queue_dialog", "F_"..mod_ids, function(self, id)
		if self["B_"..mod_ids] or not Global.game_settings or not Global.game_settings.level_id or managers.job:current_level_id() ~= "cage" then
		
		else
			if DB:has(Idstring("unit"), zipline_motor_alt_ids) then
				self["B_"..mod_ids] = true
				local function __spawn_zipline_motor_alt(pos1, pos2)
					local __zip = safe_spawn_unit(zipline_motor_alt_ids, 
						pos1, 
						Rotation()
					)
					__zip:zipline():set_end_pos(pos2)
					__zip:zipline():set_total_time(10)
				end
				local __pos1 = Vector3(-1454.03, 519.948, 210)
				local __pos2 = Vector3(-24474.7, 91884.5, 860)
				__spawn_zipline_motor_alt(__pos1, __pos2)
				__spawn_zipline_motor_alt(__pos2, __pos1)
			end
		end
	end)
end