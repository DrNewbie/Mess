Hooks:PostHook(SmokeScreenEffect, "update", "UnambiguousSmoke_update", function(self, t, dt)
	if self._timer then
		self.__UnambiguousSmoke = {}
		self.__UnambiguousSmoke._brush = self.__UnambiguousSmoke._brush or Draw:brush(Color(0.1, 1, 0.2, 1))
		self.__UnambiguousSmoke._brush:cylinder(
			self._position,
			self._position + Vector3(0, 0, 5),
			self._radius,
			50
		)
	end
end)