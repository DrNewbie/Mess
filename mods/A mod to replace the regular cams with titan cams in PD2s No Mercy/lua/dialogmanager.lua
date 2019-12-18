if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" or not Network:is_server() then

else
	local OwO_Key = Idstring('PostHook:DialogManager:queue_dialog:A mod to replace the regular cams with titan cams in PD2s No Mercy'):key()
	local UwU_Key = Idstring('units/payday2/equipment/gen_equipment_security_camera/gen_equipment_security_camera'):key()
	Hooks:PostHook(DialogManager, "queue_dialog", "F_"..OwO_Key, function(self)
		if not _G[OwO_Key] then
			_G[OwO_Key] = true
			if not Global.game_settings or not Global.game_settings.level_id or not Global.game_settings.level_id == "nmh" or not Network:is_server() then

			else
				local units = World:find_units_quick("all")
				for _, notify_unit in pairs(units) do
					if notify_unit and notify_unit:name():key() == UwU_Key then
						notify_unit:damage():run_sequence_simple("deathwish")
					end
				end
			end
		end
	end)
end

