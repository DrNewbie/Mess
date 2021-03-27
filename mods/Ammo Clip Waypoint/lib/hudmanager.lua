local mod_ids = Idstring("Ammo Clip Waypoint"):key()
local func4 = "F_"..Idstring("func4::"..mod_ids):key()
local func5 = "F_"..Idstring("func5::"..mod_ids):key()
local func6 = "F_"..Idstring("func6::"..mod_ids):key()

HUDManager[func4] = function(self, __unit)
	local ids_key = "K_"..Idstring(tostring(__unit)..":"..tostring(__unit:key())):key()..Idstring(tostring(math.random())):key()
	self[func5] = self[func5] or {}
	self[func5][ids_key] = __unit
	self:add_waypoint(
		ids_key,
		{
			icon = "wp_standard",
			distance = true,
			position = __unit:position() + Vector3(0, 0, 3),
			no_sync = true,
			present_timer = 0,
			state = "present",
			radius = 50,
			color = Color.green,
			blend_mode = "add"
		}
	)
end

Hooks:PostHook(HUDManager, "update", func6, function(self)
	if type(self[func5]) == "table" then
		for ids_key, unit in pairs(self[func5]) do
			if not unit or not alive(unit) or not unit.pickup or not unit:pickup() or unit:pickup()._picked_up then
				self:remove_waypoint(ids_key)
				self[func5][ids_key] = nil
			end
		end
	end
end)