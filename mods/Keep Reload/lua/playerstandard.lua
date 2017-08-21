local BootKeepReload_PlayerStandardinit = PlayerStandard.init

function PlayerStandard:init(...)
	self.BootKeepReload = {}
	return BootKeepReload_PlayerStandardinit(self, ...)
end

local BootKeepReload_PlayerStandard_check_action_reload = PlayerStandard._check_action_reload

function PlayerStandard:_check_action_reload(t, ...)
	self.BootKeepReload.reload_enter_expire_t = self.BootKeepReload.reload_enter_expire_t or 0
	if self._equipped_unit:base().name_id == "boot" and 
		t and type(t) == "number" and t > self.BootKeepReload.reload_enter_expire_t then
		self.BootKeepReload.reload_enter_expire_t = t + 2
		self._ext_camera:play_redirect(Idstring("reload_enter_" .. self._equipped_unit:base().name_id), 1)
		self._equipped_unit:base():tweak_data_anim_play("reload_enter", 1)
	end
	return BootKeepReload_PlayerStandard_check_action_reload(self, t, ...)
end