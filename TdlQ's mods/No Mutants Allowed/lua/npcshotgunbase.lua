local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function NPCShotgunBase:get_damage_falloff(damage, col_ray, user_unit, forced_in_steelsight)
	local umov = user_unit:movement()
	local original_current_state = umov._current_state
	umov._current_state = {
		in_steelsight = function(self)
			return forced_in_steelsight
		end
	}
	local result = ShotgunBase.get_damage_falloff(self, damage, col_ray, user_unit)
	umov._current_state = original_current_state
	return result
end
