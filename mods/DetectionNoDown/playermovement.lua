Hooks:PostHook(PlayerMovement, "post_init", "F_"..Idstring("PostHook:PlayerMovement:post_init:Detection No Down"):key(), function(self)
	self.__suspicion_ratio_hold = 0
end)

Hooks:PostHook(PlayerMovement, "_calc_suspicion_ratio_and_sync", "F_"..Idstring("PostHook:PlayerMovement:_calc_suspicion_ratio_and_sync:Detection No Down"):key(), function(self, observer_unit, status)
	if self._suspicion and type(self._suspicion_ratio) == "number" then
		local max_suspicion = nil
		for u_key, val in pairs(self._suspicion) do
			if not max_suspicion or max_suspicion < val then
				max_suspicion = val
			end
		end
		if max_suspicion then
			local __add_suspicion_amount = managers.groupai:state():__get_add_suspicion_amount()
			local __hold_suspicion_amount = managers.groupai:state():__get_hold_suspicion_amount()
			if __hold_suspicion_amount > max_suspicion then
				max_suspicion = __hold_suspicion_amount
			else
				managers.groupai:state():__set_hold_suspicion_amount(max_suspicion)
			end
			max_suspicion = max_suspicion + __add_suspicion_amount
			if max_suspicion >= 1.0 then
				self:on_suspicion(observer_unit, true)
				managers.groupai:state():__set_add_suspicion_amount(0)
				managers.groupai:state():__set_hold_suspicion_amount(0)
				managers.hud:set_suspicion(false)
				managers.groupai:state():on_criminal_suspicion_progress(self._unit, observer_unit, true)
				managers.groupai:state():criminal_spotted(self._unit)
				if observer_unit.movement and observer_unit:movement() and observer_unit:movement().set_cool then
					observer_unit:movement():set_cool(false)
				elseif observer_unit:base() and observer_unit:base().is_security_camera and observer_unit:base()._sound_the_alarm then
					observer_unit:base():__suspicion_this_one(self._unit)
				end
				self.__suspicion_ratio_hold = 0
			else
				self._suspicion_ratio = max_suspicion
				self.__suspicion_ratio_hold = max_suspicion
			end
		end
	end
end)