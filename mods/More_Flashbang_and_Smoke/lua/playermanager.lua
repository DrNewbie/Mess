if not ModCore then
	return
else
	local mod_ids = Idstring("More Flashbang and Smoke"):key()
	local mod_path = ModPath
	_G[mod_ids] = _G[mod_ids] or ModCore:new(mod_path .. "__cfg.xml", true, true)
end