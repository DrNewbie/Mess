local _f_DialogManager_queue_dialog = DialogManager.queue_dialog
function DialogManager:queue_dialog(id, ...)
	local _escape_time = 0
	if id == "Play_pln_pal_77" then -- Counterfeit , Escape
		_escape_time = 45
	elseif id == " Play_pln_man_74" then -- Undercover , Escape
		_escape_time = 45
	elseif id == "Play_pln_fwb_62" then -- First World Bank , C4 BOOM!!
		_escape_time = 120
	elseif id == "Play_pln_dn1_25" then -- Slaughterhouse , Escape
		_escape_time = 60
	elseif id == "Play_pln_hb2_19" then -- Hoxton Breakout Day2 , Bain last talk
		_escape_time = 40
	end
	if _escape_time > 0 then
		managers.groupai:state():set_point_of_no_return_timer(_escape_time, 0)
	end
    return _f_DialogManager_queue_dialog(self, id, ...)
end

