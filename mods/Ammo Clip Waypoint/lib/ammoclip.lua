local mod_ids = Idstring("Ammo Clip Waypoint"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()

Hooks:PostHook(AmmoClip, "init", func1, function(self)
	self[func3] = "K_"..Idstring(tostring(self._unit)):key()
	if managers.hud then
		managers.hud[func4](managers.hud, self._unit)
	end
end)

Hooks:PostHook(AmmoClip, "_pickup", func2, function(self)
	if self._picked_up and self[func3] then
		if managers.hud then
			managers.hud:remove_waypoint(tostring(self[func3]))
		end
		self[func3] = nil
	end
end)