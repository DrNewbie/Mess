local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mic_original_copdamage_buildsuppression = CopDamage.build_suppression
function CopDamage:build_suppression(amount, panic_chance)
	if not self._unit:base().mic_is_being_moved then
		mic_original_copdamage_buildsuppression(self, amount, panic_chance)
	end
end

local mic_original_copdamage_clbksuppressiondecay = CopDamage.clbk_suppression_decay
function CopDamage:clbk_suppression_decay()
	if alive(self._unit) and not self._unit:base().mic_is_being_moved then
		mic_original_copdamage_clbksuppressiondecay(self)
	end
end

local mic_original_copdamage_stunhit = CopDamage.stun_hit
function CopDamage:stun_hit(...)
	if self._unit:anim_data().hands_tied then
		return
	end
	mic_original_copdamage_stunhit(self, ...)
end
