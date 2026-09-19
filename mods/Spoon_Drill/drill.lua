local mod_ids = Idstring("Spoon Drill"):key()
local func1 = "F_"..Idstring("func1::"..mod_ids):key()
local func2 = "F_"..Idstring("func2::"..mod_ids):key()
local func3 = "F_"..Idstring("func3::"..mod_ids):key()
local func5 = "F_"..Idstring("func5::"..mod_ids):key()
local func6 = "F_"..Idstring("func5::"..mod_ids):key()
local spoon_gold_ids = Idstring("units/pd2_dlc_apfo/weapons/wpn_fps_mel_spoon/wpn_third_mel_spoon_gold")

Drill[func5] = function(self)
	if self._unit and self._unit:name():key() == "584bea03f3b5d712" then
		if self[func3] then
			self[func3]:unlink()
			World:delete_unit(self[func3])
			self[func3] = nil	
		end
		local drill_align = self._unit:get_object(Idstring("e_drill_particles"))
		if drill_align then
			local spoon_unit = World:spawn_unit(spoon_gold_ids, drill_align:position(), drill_align:rotation())
			self._unit:link(drill_align:name(), spoon_unit, spoon_unit:orientation_object():name())
			self[func3] = spoon_unit
			self._unit:set_visible(false)
		end
	end
end

Hooks:PostHook(Drill, "_start_drill_effect", func1, function(self)
	managers.dyn_resource:load(Idstring("unit"), spoon_gold_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, func5))
end)

Hooks:PreHook(Drill, "destroy", func6, function(self)
	if self[func3] then
		self[func3]:unlink()
		World:delete_unit(self[func3])
		self[func3] = nil
	end
end)