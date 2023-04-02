ConcussionTF2JarateGrenade = ConcussionTF2JarateGrenade or class(ConcussionGrenade)

function ConcussionTF2JarateGrenade:_can_stun_unit(__unit, ...)
	if alive(__unit) and __unit:brain() and __unit:brain().is_hostage and __unit:brain():is_hostage() then
		return false
	end
	if __unit.character_damage and __unit:character_damage() and __unit:character_damage()._apply_damage_reduction then
		__unit:character_damage().__tf2_jarate_time = TimerManager:game():time() + 10
		
		__unit:character_damage().__tf2_jarate_apply_damage_reduction = __unit:character_damage().__tf2_jarate_apply_damage_reduction or __unit:character_damage()._apply_damage_reduction
		__unit:character_damage()._apply_damage_reduction = function(them, __damage, ...)
			if them.__tf2_jarate_time and them.__tf2_jarate_time >= TimerManager:game():time() then
				__damage = __damage * 2
			end
			return them.__tf2_jarate_apply_damage_reduction(them, __damage, ...)
		end

		local my_head = __unit:get_object(Idstring("Head"))
		if my_head then
			if __unit:character_damage().__tf2_jarate_effect then
				World:effect_manager():fade_kill(__unit:character_damage().__tf2_jarate_effect)
			end
			__unit:character_damage().__tf2_jarate_effect = World:effect_manager():spawn({
				effect = Idstring("effects/particles/fire/small_light_fire"),
				parent = my_head
			})
			DelayedCalls:Add("tf2_jarate_effect_"..tostring(__unit:id()), 10, function()
				if __unit:character_damage().__tf2_jarate_effect then
					World:effect_manager():fade_kill(__unit:character_damage().__tf2_jarate_effect)
				end
			end)
		end
	end
	return ConcussionGrenade._can_stun_unit(self, __unit, ...)
end

if Network and Network:is_client() then
	tweak_data.blackmarket.projectiles.concussion.name_id = "bm_concussion_tf2_jarate_not_working"
end