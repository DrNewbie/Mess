Hooks:PostHook(PlayerInventory, "_start_feedback_effect", "F_"..Idstring("PostHook:PlayerInventory:_start_feedback_effect:Mademoiselle Pocket ECM"):key(), function(self)
	if self._jammer_data and self._jammer_data.sound then
		self._unit:sound_source():post_event("ecm_jammer_puke_signal_stop")
		self._jammer_data.sound = self._unit:sound_source():post_event("errrrrrrrrrr_001")
	end
end)

Hooks:PostHook(PlayerInventory, "_start_jammer_effect", "F_"..Idstring("PostHook:PlayerInventory:_start_jammer_effect:Mademoiselle Pocket ECM"):key(), function(self)
	if self._jammer_data and self._jammer_data.sound then
		self._unit:sound_source():post_event("ecm_jammer_jam_signal_stop")
		self._jammer_data.sound = self._unit:sound_source():post_event("errrrrrrrrrr_001")
	end
end)