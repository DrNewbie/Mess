Hooks:PostHook(MissionManager, "init", "F_"..Idstring("PostHook:MissionManager:init:Plant Head:PwP"):key(), function(self)
	if Global.level_data and Global.level_data.level_id and not PackageManager:unit_data(Idstring("units/pd2_dlc2/props/bnk_prop_lobby_plant_dracaenafragrans/bnk_prop_lobby_plant_dracaenafragrans_b")) then
		if PackageManager:package_exists("levels/instances/unique/hox_fbi_armory/world/world") and not PackageManager:loaded("levels/instances/unique/hox_fbi_armory/world/world") then
			PackageManager:load("levels/instances/unique/hox_fbi_armory/world/world")
		end
	end
end)