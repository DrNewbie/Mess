if Network:is_client() then
	return
end

_G.ShadowRaidLoud = _G.ShadowRaidLoud or {}

local _f_start_single_player_job = MenuCallbackHandler.start_single_player_job
local _f_start_job = MenuCallbackHandler.start_job

function MenuCallbackHandler:start_single_player_job(...)
	managers.menu:show_ShadowRaidLoud_warning()
	return _f_start_single_player_job(self, ...)
end

function MenuCallbackHandler:start_job(...)
	managers.menu:show_ShadowRaidLoud_warning()
	return _f_start_job(self, ...)
end

function MenuManager:show_ShadowRaidLoud_warning()
	local dialog_data = {}
	dialog_data.title = "!! WARNING !!"
	dialog_data.text = ShadowRaidLoud.Message2WarnYou
	local ok_button = {}
	ok_button.text = managers.localization:text("dialog_ok")
	dialog_data.button_list = {ok_button}
	managers.system_menu:show(dialog_data)
end