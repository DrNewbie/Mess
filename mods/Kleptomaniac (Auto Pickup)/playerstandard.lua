function PlayerStandard:_find_pickups_kleptomaniac(list)
	local pickups = World:find_units_quick("sphere", self._unit:movement():m_pos(), 200) or {}
	if pickups and #pickups > 0 then
		for _, pickup in pairs(pickups) do
			if pickup:interaction() and type(pickup:interaction().tweak_data) == "string" and list[pickup:interaction().tweak_data] then
				if pickup:interaction():can_select(self._unit) and not pickup:interaction():_interact_blocked(self._unit) then
					pickup:interaction():interact(self._unit)
				end
			end
		end
	end
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", "F_"..Idstring("Post.PlyStand._update_check_actions.Kleptomaniac"):key(), function(self)
	if self._find_pickups_kleptomaniac_dt then
		self._find_pickups_kleptomaniac_dt = nil
	else
		self._find_pickups_kleptomaniac_dt = true
		self:_find_pickups_kleptomaniac({pickup_keycard = true})
	end
end)