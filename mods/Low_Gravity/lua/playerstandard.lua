Hooks:PostHook(PlayerStandard, "update", "F_"..Idstring("PlayerStandard:update:Low Gravity"):key(), function(self)
	if self._unit and alive(self._unit) and type(self._unit.mover) == "function" and self._unit:mover() and not self.__old_gravity then
		self.__old_gravity = self._unit:mover():gravity()
		self._unit:mover():set_gravity(Vector3(self.__old_gravity.x, self.__old_gravity.y, self.__old_gravity.z * 0.1))
	end
end)