Hooks:PostHook(MenuCallbackHandler, '_increase_infamous', 'F_'..Idstring('_increase_infamous'):key(), function(self)
	while managers.experience:current_level() < 100 do
		managers.experience:_level_up()
	end
end)

local old_become_infamous = MenuCallbackHandler.become_infamous

function MenuCallbackHandler:become_infamous(...)
	if self:can_become_infamous() and managers.experience:current_level() == 100 then
		local __rate = managers.experience:next_level_data_current_points() / managers.experience:next_level_data_points()
		local __Trate = math.min(math.round(__rate * 40) - 1, 40)
		local __Rrate = math.min(math.round(__rate * 100), 100)
		local __Ttext = ""
		__Ttext = string.rep("/", __Trate) .. string.rep("-", 40-__Trate)
		QuickMenu:new(
			""..utf8.to_upper(managers.localization:text("menu_infamy_button_go_infamous")).."",
			"[ "..__Ttext.." ] "..__Rrate.."%",
			{{text = "Ok", is_cancel_button = true}},
			true
		):Show()
		return
	end
	return old_become_infamous(self, ...)
end