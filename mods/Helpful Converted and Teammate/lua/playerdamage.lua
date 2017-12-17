_G.HelpfulConverted = _G.HelpfulConverted or {}

HelpfulConverted.Playing = HelpfulConverted.Playing or {}

local HelpfulConverted_revive = PlayerDamage.revive

function PlayerDamage:revive(...)
	local _rescuer = HelpfulConverted.Playing[self._unit:key()] or nil
	if _rescuer and alive(_rescuer) and _rescuer:brain() then
		_rescuer:brain():set_objective({
			type = "act",
			action = {
				type = "act",
				body_part = 1,
				variant = "idle",
				blocks = {
					idle = -1,
					turn = -1,
					action = -1,
					walk = -1,
					light_hurt = -1,
					hurt = -1,
					heavy_hurt = -1,
					expl_hurt = -1,
					fire_hurt = -1
				}
			}
		})
	end
	HelpfulConverted.Playing[self._unit:key()] = nil
	return HelpfulConverted_revive(self, ...)
end