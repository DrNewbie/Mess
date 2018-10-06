--[[
_G.FPVOTR = _G.FPVOTR or {}

Hooks:PostHook(FragGrenade, "_setup_from_tweak_data", "FPVOTR_setup_from_tweak_data", function(self)
	self._init_timer = 9999
end)
]]