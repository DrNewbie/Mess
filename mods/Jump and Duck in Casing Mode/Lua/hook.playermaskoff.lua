local mod_ids = Idstring('Jump and Duck in Casing Mode'):key()

Hooks:PostHook(PlayerMaskOff, "_check_action_jump", 'F_'..Idstring("PostHook:PlayerMaskOff:_check_action_jump:"..mod_ids):key(), function(self, t, input)
	if input.btn_jump_press then
		PlayerStandard._check_action_jump(self, t, input)
	end
end)

Hooks:PostHook(PlayerMaskOff, "_check_action_duck", 'F_'..Idstring("PostHook:PlayerMaskOff:_check_action_duck:"..mod_ids):key(), function(self, t, input)
	if input.btn_duck_release or input.btn_duck_press then
		PlayerStandard._check_action_duck(self, t, input)
	end
end)

Hooks:PostHook(PlayerMaskOff, "_check_action_interact", 'F_'..Idstring("PostHook:PlayerMaskOff:_check_action_interact:"..mod_ids):key(), function(self)
	return true
end)

Hooks:PostHook(PlayerMaskOff, "_upd_attention", 'F_'..Idstring("PostHook:PlayerMaskOff:_upd_attention:"..mod_ids):key(), function(self)
	if self._state_data.ducking then
		PlayerStandard._upd_attention(self)
	end
end)