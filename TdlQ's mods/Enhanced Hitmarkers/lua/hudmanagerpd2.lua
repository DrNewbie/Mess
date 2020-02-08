local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function HUDManager:on_damage_confirmed(kill_confirmed, headshot)
	if managers.user:get_setting('hit_indicator') then
		self._hud_hit_confirm:on_damage_confirmed(kill_confirmed, headshot)
	end
end
