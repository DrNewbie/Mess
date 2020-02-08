local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function PlayerMovement:clbk_attention_notice_sneak(observer_unit, status)
	if alive(observer_unit) and not observer_unit:base().mic_is_being_moved then
		self:on_suspicion(observer_unit, status)
	end
end
