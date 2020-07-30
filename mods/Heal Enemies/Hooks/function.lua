local function _SaveThisCopBackAgain(damage_ex)
	if damage_ex then
		local __heal = damage_ex._HEALTH_INIT * 2
		damage_ex._health = math.min(damage_ex._health + math.abs(__heal), damage_ex._HEALTH_INIT)
		damage_ex._health_ratio = damage_ex._health_ratio / damage_ex._HEALTH_INIT
		damage_ex:_send_bullet_attack_result({}, damage_ex._unit, -0.1, CopDamage.BODY_INDEX_MAX, 0, 3)
		if damage_ex._unit:contour() then
			damage_ex._unit:contour():add("medic_heal", true)
			damage_ex._unit:contour():flash("medic_heal", 0.2)
		end
	end
	return
end


if CopDamage then
	Hooks:PostHook(CopDamage, "_apply_damage_to_health", "F_"..Idstring("CopDamage:_apply_damage_to_health:_SaveThisCopBackAgain"):key(), function(self)
		_SaveThisCopBackAgain(self)
	end)
end

if HuskCopDamage then
	Hooks:PostHook(HuskCopDamage, "_apply_damage_to_health", "F_"..Idstring("HuskCopDamage:_apply_damage_to_health:_SaveThisCopBackAgain"):key(), function(self)
		_SaveThisCopBackAgain(self)
	end)
end