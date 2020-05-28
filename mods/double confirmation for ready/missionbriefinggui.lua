local __old_on_ready_pressed = MissionBriefingGui.on_ready_pressed
function MissionBriefingGui:on_ready_pressed(rdy, ...)
	if not rdy and not self._ready and managers.system_menu then
		local opts = {}
		opts[#opts+1] = {text = "[No]", is_cancel_button = true}
		opts[#opts+1] = {text = "[No]", is_cancel_button = true}
		opts[#opts+1] = {text = "[No]", is_cancel_button = true}
		opts[#opts+1] = {text = "[Yes]", callback_func = callback(self, self, "on_ready_pressed", true)}
		opts[#opts+1] = {text = "[No]", is_cancel_button = true}
		managers.system_menu:show({
			title = "[Double Confirmation]",
			text = "Are you ready?",
			button_list = opts,
			id = "Random_Temp_Menu_"..Idstring(tostring(os.time())):key()
		})
		return
	end
	return __old_on_ready_pressed(self, rdy, ...)
end