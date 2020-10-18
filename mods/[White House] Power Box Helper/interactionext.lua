local mod_ids = Idstring("Power Box Helper"):key()
local func1 = "F_"..Idstring("func1:"..mod_ids):key()
local func2 = "F_"..Idstring("func2:"..mod_ids):key()
local func3 = "F_"..Idstring("func3:"..mod_ids):key()

Hooks:PostHook(UseInteractionExt, "set_tweak_data", func1, function(self, active)
	if Global.load_level == true and Global.level_data.level_id == "vit" then 
		if self._unit:name() == Idstring("units/pd2_dlc_vit/props/vit_prop_cable_box/vit_prop_cable_box") then
			self[func3] = "F_"..Idstring(tostring(self._unit:key()) .. ":" .. tostring(math.random())):key()
		end
	end
end)

Hooks:PostHook(UseInteractionExt, "set_active", func2, function(self, active)
	if self[func3] and type(active) == "boolean" then
		if active == true then
			managers.hud:add_waypoint(
				self[func3], {
				icon = "pd2_wirecutter",
				distance = true,
				position = self._unit:position(),
				no_sync = true,
				present_timer = 0,
				state = "present",
				radius = 50,
				color = Color.green,
				blend_mode = "add"
			})
		else
			managers.hud:remove_waypoint(self[func3])
		end
	end
end)