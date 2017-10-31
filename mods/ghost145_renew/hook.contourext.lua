m_ghost._qualify = m_ghost:mode()
local dur = m_ghost:mode() >= 3 and 0 or m_ghost:mode() == 2 and 6 or 13.5
ContourExt._types.mark_enemy.fadeout_silent = dur
ContourExt._types.mark_enemy_damage_bonus.fadeout_silent = dur
ContourExt._types.mark_enemy_damage_bonus_distance.fadeout_silent = dur

local Ghost145Plus_ContourExt_add = ContourExt.add

function ContourExt:add(type, sync, multiplier)
	if type == 'mark_enemy' or type == 'mark_enemy_damage_bonus' or type == 'mark_enemy_damage_bonus_distance' then
		if m_ghost:mode() >= 3 then
			self:remove(type, true)
			return
		elseif m_ghost:mode() == 2 then
			multiplier = 0.5
		end
		sync = true
	end
	return Ghost145Plus_ContourExt_add(self, type, sync, multiplier)
end