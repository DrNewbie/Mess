local _say_Get_The_Thermal_Drill = DialogManager.queue_dialog

function DialogManager:queue_dialog(id, params)
	id = "pln_branchbank_stage1_83"
	return _say_Get_The_Thermal_Drill(self, id, params)
end