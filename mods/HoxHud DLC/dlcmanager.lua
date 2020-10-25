Hooks:PostHook(WINDLCManager, "init", "F_"..Idstring("WINDLCManager:init:HoxHud DLC"):key(), function(self)
	Global.dlc_manager.all_dlc_data.hoxhud_group = {
		source_id = "103582791435633447"
	}
end)

function GenericDLCManager:has_hoxhud_group(_userid)
	if not Steam or not Steam.userid or not Steam.is_user_in_source or not Global.dlc_manager or not Global.dlc_manager.all_dlc_data or not Global.dlc_manager.all_dlc_data.hoxhud_group then
		return false
	end
	if type(_userid) ~= "string" then
		_userid = Steam:userid()
	end
	return Steam:is_user_in_source(_userid, Global.dlc_manager.all_dlc_data.hoxhud_group.source_id)
end