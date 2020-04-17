function SecurityCamera:__suspicion_this_one(__on_no)
	self.__suspicion_this_unit = __on_no
end

Hooks:PostHook(SecurityCamera, "_upd_suspicion", "F_"..Idstring("PostHook:SecurityCamera:_upd_suspicion:Detection No Down"):key(), function(self)
	if self.__suspicion_this_unit then
		local __unit = self.__suspicion_this_unit
		self.__suspicion_this_unit = nil
		self:_destroy_all_detected_attention_object_data()
		self:set_detection_enabled(false, nil, nil)
		__unit:movement():on_uncovered(self._unit)
		self:_sound_the_alarm(__unit)
	end
end)