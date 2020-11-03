local old_play_unequip_animation = PlayerStandard._play_unequip_animation
function PlayerStandard:_play_unequip_animation(...)
	if self._interact_expire_t and self._ext_inventory and self._ext_inventory:equipped_unit() then
		local wep_base = self._ext_inventory:equipped_unit():base()
		if wep_base._blueprint then
			return		
		end
	end
	return old_play_unequip_animation(self, ...)
end

local old_check_action_primary_attack = PlayerStandard._check_action_primary_attack

function PlayerStandard:_check_action_primary_attack(t, input, ...)
	local __ans = old_check_action_primary_attack(self, t, input, ...)
	if not __ans and self:_interacting() then
		local new_action = nil
		local action_wanted = input.btn_primary_attack_state or input.btn_primary_attack_release
		if action_wanted then
			local action_forbidden = self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_is_throwing_projectile() or self:_is_deploying_bipod() or self._menu_closed_fire_cooldown > 0 or self:is_switching_stances()
			local weap_base = self._equipped_unit:base()
			if not action_forbidden and not (weap_base.clip_empty and weap_base:clip_empty()) then
				self._queue_reload_interupt = nil
				local start_shooting = false
				self._ext_inventory:equip_selected_primary(false)
				if self._equipped_unit then
					local fire_mode = weap_base:fire_mode()
					local fire_on_release = weap_base:fire_on_release()
					if weap_base:out_of_ammo() then
						if input.btn_primary_attack_press then
							weap_base:dryfire()
						end
					elseif weap_base.clip_empty and weap_base:clip_empty() then
						if self:_is_using_bipod() then
							if input.btn_primary_attack_press then
								weap_base:dryfire()
							end
							self._equipped_unit:base():tweak_data_anim_stop("fire")
						elseif fire_mode == "single" then
							if input.btn_primary_attack_press or self._equipped_unit:base().should_reload_immediately and self._equipped_unit:base():should_reload_immediately() then
								self:_start_action_reload_enter(t)
							end
						else
							new_action = true
							self:_start_action_reload_enter(t)
						end
					elseif self._running and not self._equipped_unit:base():run_and_shoot_allowed() then
						self:_interupt_action_running(t)
					else
						if not self._shooting then
							if weap_base:start_shooting_allowed() then
								local start = fire_mode == "single" and input.btn_primary_attack_press
								start = start or fire_mode ~= "single" and input.btn_primary_attack_state
								start = start and not fire_on_release
								start = start or fire_on_release and input.btn_primary_attack_release
								if start then
									weap_base:start_shooting()
									self._camera_unit:base():start_shooting()
									self._shooting = true
									self._shooting_t = t
									start_shooting = true
									if fire_mode == "auto" then
										self._unit:camera():play_redirect(self:get_animation("recoil_enter"))
										if (not weap_base.akimbo or weap_base:weapon_tweak_data().allow_akimbo_autofire) and (not weap_base.third_person_important or weap_base.third_person_important and not weap_base:third_person_important()) then
											self._ext_network:send("sync_start_auto_fire_sound", 0)
										end
									end
								end
							else
								self:_check_stop_shooting()
								return false
							end
						end
						local suppression_ratio = self._unit:character_damage():effective_suppression_ratio()
						local spread_mul = math.lerp(1, tweak_data.player.suppression.spread_mul, suppression_ratio)
						local autohit_mul = math.lerp(1, tweak_data.player.suppression.autohit_chance_mul, suppression_ratio)
						local suppression_mul = managers.blackmarket:threat_multiplier()
						local dmg_mul = managers.player:temporary_upgrade_value("temporary", "dmg_multiplier_outnumbered", 1)
						if managers.player:has_category_upgrade("player", "overkill_all_weapons") or weap_base:is_category("shotgun", "saw") then
							dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
						end
						local health_ratio = self._ext_damage:health_ratio()
						local primary_category = weap_base:weapon_tweak_data().categories[1]
						local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, primary_category)
						if damage_health_ratio > 0 then
							local upgrade_name = weap_base:is_category("saw") and "melee_damage_health_ratio_multiplier" or "damage_health_ratio_multiplier"
							local damage_ratio = damage_health_ratio
							dmg_mul = dmg_mul * (1 + managers.player:upgrade_value("player", upgrade_name, 0) * damage_ratio)
						end
						dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
						dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
						local fired = nil
						if fire_mode == "single" then
							if input.btn_primary_attack_press and start_shooting then
								fired = weap_base:trigger_pressed(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
							elseif fire_on_release then
								if input.btn_primary_attack_release then
									fired = weap_base:trigger_released(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
								elseif input.btn_primary_attack_state then
									weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
								end
							end
						elseif input.btn_primary_attack_state then
							fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
						end
						if weap_base.manages_steelsight and weap_base:manages_steelsight() then
							if weap_base:wants_steelsight() and not self._state_data.in_steelsight then
								self:_start_action_steelsight(t)
							elseif not weap_base:wants_steelsight() and self._state_data.in_steelsight then
								self:_end_action_steelsight(t)
							end
						end
						local charging_weapon = fire_on_release and weap_base:charging()
						if not self._state_data.charging_weapon and charging_weapon then
							self:_start_action_charging_weapon(t)
						elseif self._state_data.charging_weapon and not charging_weapon then
							self:_end_action_charging_weapon(t)
						end
						new_action = true
						if fired then
							managers.rumble:play("weapon_fire")
							local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
							local shake_multiplier = weap_tweak_data.shake[self._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier"]
							self._ext_camera:play_shaker("fire_weapon_rot", 1 * shake_multiplier)
							self._ext_camera:play_shaker("fire_weapon_kick", 1 * shake_multiplier, 1, 0.15)
							self._equipped_unit:base():tweak_data_anim_stop("unequip")
							self._equipped_unit:base():tweak_data_anim_stop("equip")
							if not self._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()) then
								weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
							end
							if fire_mode == "single" and weap_base:get_name_id() ~= "saw" then
								if not self._state_data.in_steelsight then
									self._ext_camera:play_redirect(self:get_animation("recoil"), weap_base:fire_rate_multiplier())
								elseif weap_tweak_data.animations.recoil_steelsight then
									self._ext_camera:play_redirect(weap_base:is_second_sight_on() and self:get_animation("recoil") or self:get_animation("recoil_steelsight"), 1)
								end
							end
							local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()
							local up, down, left, right = unpack(weap_tweak_data.kick[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])
							self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
							if self._shooting_t then
								local time_shooting = t - self._shooting_t
								local achievement_data = tweak_data.achievement.never_let_you_go
								if achievement_data and weap_base:get_name_id() == achievement_data.weapon_id and achievement_data.timer <= time_shooting then
									managers.achievment:award(achievement_data.award)
									self._shooting_t = nil
								end
							end
							if managers.player:has_category_upgrade(primary_category, "stacking_hit_damage_multiplier") then
								self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
								self._state_data.stacking_dmg_mul[primary_category] = self._state_data.stacking_dmg_mul[primary_category] or {
									nil,
									0
								}
								local stack = self._state_data.stacking_dmg_mul[primary_category]
								if fired.hit_enemy then
									stack[1] = t + managers.player:upgrade_value(primary_category, "stacking_hit_expire_t", 1)
									stack[2] = math.min(stack[2] + 1, tweak_data.upgrades.max_weapon_dmg_mul_stacks or 5)
								else
									stack[1] = nil
									stack[2] = 0
								end
							end
							if weap_base.set_recharge_clbk then
								weap_base:set_recharge_clbk(callback(self, self, "weapon_recharge_clbk_listener"))
							end
							managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())
							local impact = not fired.hit_enemy
							if weap_base.third_person_important and weap_base:third_person_important() then
								self._ext_network:send("shot_blank_reliable", impact, 0)
							elseif weap_base.akimbo and not weap_base:weapon_tweak_data().allow_akimbo_autofire or fire_mode == "single" then
								self._ext_network:send("shot_blank", impact, 0)
							end
						elseif fire_mode == "single" then
							new_action = false
						end
					end
				end
			elseif self:_is_reloading() and self._equipped_unit:base():reload_interuptable() and input.btn_primary_attack_press then
				self._queue_reload_interupt = true
			end
		end
		if not new_action then
			self:_check_stop_shooting()
		end
		return new_action
	end
	return __ans
end