function MenuManager:show_accept_telemetry(params)
	managers.user:set_setting("use_telemetry", false, true)
	MenuCallbackHandler:save_settings()
end