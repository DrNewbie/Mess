if not ModCore then
	log("[ERROR] BeardLib is not installed!")
	return
end

_G.FileReloader = _G.FileReloader or {}

MenuCallbackHandler:FileReloader_Choose_Folder_callback()