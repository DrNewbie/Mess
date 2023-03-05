local ThisModPath = ModPath

if (Network and Network:is_server()) or Global.game_settings.single_player then

else
	return
end	

local __Name = function(__id)
	return "DDD_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")
local is_okay = __Name("is_okay")

local function is_okay_drill(__unit)
	if __unit and alive(__unit) and type(__unit.base) == "function" and __unit:base() and __unit:base()[is_okay] then
		return true
	end
	return false
end

if Drill and not Drill[is_bool] then
	Drill[is_bool] = true
	Hooks:PostHook(Drill, "set_skill_upgrades", __Name("1"), function(self, ...)
		if (self.is_drill or self.is_saw) and self._unit and alive(self._unit) and type(self._unit.timer_gui) == "function" and self._unit:timer_gui() and type(self._unit:timer_gui().update) == "function" then
			self[is_okay] = true
		end
	end)
end

if TimerGui and not TimerGui[is_bool] then
	TimerGui[is_bool] = true
	Hooks:PostHook(TimerGui, "update", __Name("2"), function(self, __unit, __t, __dt, ...)
		if self[is_okay] and is_okay_drill(self._unit) and not self._jammed and self._powered then
			self[is_okay] = false
			local __dt_mod = math.max(self._timer_multiplier or 1, 0.01)
			if type(self._current_jam_timer) == "number" and self._current_jam_timer > 3 then
				self._current_timer = self._current_timer - (__dt / __dt_mod) * 2
				self._time_left = self._current_timer * __dt_mod
			end
		end
	end)
end

if PlayerStandard and not PlayerStandard[is_bool] then
	PlayerStandard[is_bool] = true
	Hooks:PostHook(PlayerStandard, "update", __Name("3"), function(self, __t, __dt, ...)
		if self:_is_meleeing() then
			local __col_ray = self:_calc_melee_hit_ray(__t, 5)
			if __col_ray and is_okay_drill(__col_ray.unit) and type(__col_ray.unit.timer_gui) == "function" and __col_ray.unit:timer_gui() and type(__col_ray.unit:timer_gui().update) == "function" then
				__col_ray.unit:timer_gui()[is_okay] = true
			end
		end
	end)
end