local ThisModPath = ModPath

local __Name = function(__id)
	return "DDD_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local ids_drill = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small")

local is_bool = __Name("is_bool")
local is_done = __Name("is_done")
local __Child_Drill = __Name("__Child_Drill")
local __Child_Drill_Index = __Name("__Child_Drill_Index")

local function __check_unit(__u)
	if __u and alive(__u) and 
		type(__u.base) == "function" and  __u:base() and 
		type(__u.timer_gui) == "function" and __u:timer_gui() and 
		type(__u.interaction) == "function" and __u:interaction() then
		return true
	end
	return false
end

local function __spawn_drill(__o, __p, __offset)
	local new_drill_unit = nil
	if __check_unit(__o) and __check_unit(__p) then
		local drill_align = __p:get_object(Idstring("g_base"))
		if drill_align then
			local __y = __p:rotation():y()
			new_drill_unit = World:spawn_unit(ids_drill, __p:position() - __y * 30, __p:rotation())
			if __check_unit(new_drill_unit) then
				local __current_timer = __p:timer_gui()._current_timer or 3
				if __current_timer <= 0 then
					__current_timer = __o:timer_gui()._current_timer or 3
				end
				if __current_timer <= 0 then
					__current_timer = 3
				end
				new_drill_unit:timer_gui():set_can_jam(false)
				new_drill_unit:timer_gui():set_override_timer(__current_timer * 0.66 - __offset * 0.0000001)
				new_drill_unit:base()[is_bool] = true
				new_drill_unit:base()._disable_upgrades = true
				new_drill_unit:interaction():interact()
				new_drill_unit:interaction():set_active(false, true)
			end
		end
	end
	return new_drill_unit
end

if BaseInteractionExt and not BaseInteractionExt[is_done] then
	BaseInteractionExt[is_done] = true
	Hooks:PostHook(BaseInteractionExt, "interact", __Name("interact"), function(self, ...)
		if self._unit and self._unit:name() == ids_drill and not self._unit:base()[is_bool] then
			self._unit:base()[__Child_Drill] = self._unit:base()[__Child_Drill] or {}
			self._unit:base()[__Child_Drill_Index] = self._unit:base()[__Child_Drill_Index] or 0
			local drill_index = self._unit:base()[__Child_Drill_Index]
			local __new_drill_unit
			if drill_index > 0 then
				local off_set = 1
				local p_unit = self._unit
				local s_drills = self._unit:base()[__Child_Drill]
				for _, s_drill in pairs(s_drills) do
					if s_drill and alive(s_drill) and s_drill:base() then
						off_set = off_set + 1
						p_unit = s_drill
					end
				end
				__new_drill_unit = __spawn_drill(self._unit, p_unit, off_set)
				if __new_drill_unit then
					table.insert(self._unit:base()[__Child_Drill], __new_drill_unit)
				end
			end
			self._unit:base()[__Child_Drill_Index] = drill_index + 1
		end
	end)
end

if Drill and not Drill[is_done] then
	Drill[is_done] = true	
	Hooks:PreHook(Drill, "done", __Name("done"), function(self, ...)
		local __child_drill = self._unit:base()[__Child_Drill]
		if type(__child_drill) == "table" then
			for _, s_drill in pairs(__child_drill) do
				if s_drill and alive(s_drill) then
					s_drill:set_slot(0)
				end
				if s_drill and alive(s_drill) then
					World:delete_unit(s_drill)
				end
			end
		end
	end)
end