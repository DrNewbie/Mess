local FullyChargedPerkShotEvent = CopDamage.damage_bullet

function CopDamage:damage_bullet(attack_data)
	local explosion_headshot = {}
	if attack_data and attack_data.damage and attack_data.attacker_unit and alive(attack_data.attacker_unit) and attack_data.attacker_unit == managers.player:player_unit() then
		local player = attack_data.attacker_unit
		if player then
			local damage_ex = player:character_damage()
			if damage_ex and damage_ex:get_real_armor() > 1 and not damage_ex:arrested() and not damage_ex:need_revive() then
				if managers.player:has_category_upgrade("player", "passive_fully_charged_headshot_ony") then
					local head = self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
					if not head then
						return
					end
				end
				if managers.player:has_category_upgrade("player", "passive_fully_charged_armor2damage") then
					local armor = damage_ex:get_real_armor()
					damage_ex:set_armor(0)
					damage_ex:_send_set_armor()
					damage_ex:_update_armor_hud(0, 0.1)
					damage_ex:damage_simple({
						damage = 0.01,
						variant = "bullet"
					})
					attack_data.damage = attack_data.damage * (1+(armor/100))
				end
				if managers.player:has_category_upgrade("player", "passive_fully_charged_far2damage") then
					local distance = mvector3.distance(self._unit:position(), player:position())
					attack_data.damage = attack_data.damage * (1+(distance/1500))
				end
				if managers.player:has_category_upgrade("player", "passive_fully_charged_time2damage") then
					local in_steelsight = player:movement() and player:movement():current_state() and player:movement():current_state():in_steelsight() or false
					if in_steelsight then
						local fct = player:movement() and player:movement():current_state() and player:movement():current_state()._fully_charged_time2damage_t or 0
						if fct > 0 then
							fct = TimerManager:game():time() - fct
							if fct > 0 then
								attack_data.damage = attack_data.damage * (1+(fct/20))
								player:movement():current_state()._fully_charged_time2damage_t = TimerManager:game():time()
							end
						end
					end
				end
				local explosive_headshot = managers.player:upgrade_value("player", "passive_fully_charged_explosive_headshot_1", 0)
				explosive_headshot = explosive_headshot + managers.player:upgrade_value("player", "passive_fully_charged_explosive_headshot_2", 0)
				if explosive_headshot > 1 then
					local pos = self._unit and self._unit:position()
					explosion_headshot = {
						hit_pos = pos,
						range = explosive_headshot,
						alert_radius = explosive_headshot*10,
						damage = attack_data.damage*0.25,
						player = player
					}
				end
			end
			managers.player:set_fullycharged_hit(self._unit)
		end
	end
	local Ans = FullyChargedPerkShotEvent(self, attack_data)
	if explosion_headshot and explosion_headshot.hit_pos then
		managers.explosion:play_sound_and_effects(
			explosion_headshot.hit_pos,
			math.UP,
			explosion_headshot.range,
			{
				sound_event = "grenade_explode",
				effect = "effects/payday2/particles/explosions/grenade_explosion",
				camera_shake_max_mul = 4,
				sound_muffle_effect = true,
				feedback_range = explosion_headshot.range * 2
			}
		)
		managers.explosion:detect_and_give_dmg({
			player_damage = 0,
			hit_pos = explosion_headshot.hit_pos,
			range = explosion_headshot.range,
			collision_slotmask = managers.slot:get_mask("explosion_targets"),
			curve_pow = 5,
			damage = explosion_headshot.damage,
			ignore_unit = {player},
			alert_radius = explosion_headshot.alert_radius,
			user = explosion_headshot.player,
			owner = explosion_headshot.player
		})
	end
	return Ans
end