if PlayerManager then
	function PlayerManager:IsUsingMadMilk()
		if not self:local_player() or not self:local_player():character_damage() then
			return false
		end
		if managers.blackmarket:equipped_grenade() ~= "mad_milk" then
			return false
		end
		return true
	end
	
	Hooks:PostHook(PlayerManager, "add_grenade_amount", "MadMilkPerkDeck_Used", function(self, amount)
		if self:IsUsingMadMilk() and amount and amount < 0 then
			self.__mad_milk_dt = 0
			self:local_player():character_damage():restore_health(
				self:local_player():character_damage():_max_health()*0.15,						
				true
			)
			self.__mad_milk_hp_dt = 5
		end
	end)

	Hooks:PostHook(PlayerManager, "update", "MadMilkPerkDeck_loop_timer", function(self, t, dt)
		if not Utils or not Utils:IsInHeist() or not self:IsUsingMadMilk() then
		
		else
			local time_left = self:get_timer_remaining("replenish_grenades") or 0
			if time_left > 0 then
				local tweak = tweak_data.blackmarket.projectiles["mad_milk"]
				self.__mad_milk_dt = self.__mad_milk_dt or 0
				self._timers.replenish_grenades.t = math.max(tweak.base_cooldown - self.__mad_milk_dt, 0)
				if self._timers.replenish_grenades.t <= 0 and self.__mad_milk_dt > 0 then
					self.__mad_milk_dt = 0
					if tweak.sounds.cooldown then
						self:player_unit():sound():play(tweak.sounds.cooldown)
					end
				end
				managers.hud:set_player_grenade_cooldown({
					end_time = managers.game_play_central:get_heist_timer() + self._timers.replenish_grenades.t,
					duration = tweak.base_cooldown
				})
			end
			if self.__mad_milk_hp_dt then
				self.__mad_milk_hp_dt = self.__mad_milk_hp_dt - dt
				if self.__mad_milk_hp_bool then
					self.__mad_milk_hp_bool = false
				else
					self.__mad_milk_hp_bool = true
				end
				if self.__mad_milk_hp_dt < 0 then
					self.__mad_milk_hp_bool = true
				end
				if self.__mad_milk_hp_bool then
					self:local_player():character_damage():restore_health(
						self:local_player():character_damage():_max_health()*0.001,						
						true
					)
				end
				if self.__mad_milk_hp_dt < 0 then
					self.__mad_milk_hp_dt = nil
					self.__mad_milk_hp_bool = nil
				end
			end
		end
	end)
	
	Hooks:PostHook(PlayerManager, "aquire_equipment", "MadMilkPerkDeck_aquire_default", function(self)
		if not managers.upgrades:aquired("mad_milk") then
			managers.upgrades:_aquire_upgrade(tweak_data.upgrades.definitions["mad_milk"], "mad_milk", true)
			self.__mad_milk_dt = 0
		end
	end)
end

if PlayerDamage then
	function PlayerDamage:__apply_dmg_to_mad_milk(__dmg)
		if managers.player:IsUsingMadMilk() then
			managers.player.__mad_milk_dt = managers.player.__mad_milk_dt or 0
			managers.player.__mad_milk_dt = managers.player.__mad_milk_dt + math.abs(__dmg * 6.67)
		end
		return __dmg
	end
	local old_calc_armor_damage = PlayerDamage._calc_armor_damage
	function PlayerDamage:_calc_armor_damage(attack_data, ...)
		return self:__apply_dmg_to_mad_milk(old_calc_armor_damage(self, attack_data, ...))
	end
	local old_calc_health_damage = PlayerDamage._calc_health_damage
	function PlayerDamage:_calc_health_damage(attack_data, ...)
		return self:__apply_dmg_to_mad_milk(old_calc_health_damage(self, attack_data, ...))
	end
end

if BlackMarketTweakData then
	Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "MadMilkPerkDeck_init_projectiles", function(self, tweak_data)
		self.projectiles.mad_milk = {
			name_id = "bm_grenade_mad_milk",
			desc_id = "bm_grenade_mad_milk_desc",
			icon = "damage_control",
			ability = true,
			throwable = nil,
			texture_bundle_folder = "mad_milk",
			max_amount = 1,
			base_cooldown = 1000,
			sounds = {
				cooldown = "perkdeck_cooldown_over"
			}
		}		
	end)
end

if UpgradesTweakData then
	Hooks:PostHook(UpgradesTweakData, "_grenades_definitions", "MadMilkPerkDeck_grenades_definitions", function(self)
		self.definitions.mad_milk = {category = "grenade"}
	end)
end

if NetworkMatchMakingSTEAM then
	local old_set_attributes = NetworkMatchMakingSTEAM.set_attributes
	function NetworkMatchMakingSTEAM:set_attributes(settings, ...)
		settings.numbers[3] = 3
		return old_set_attributes(self, settings, ...)
	end

	local old_is_server_ok = NetworkMatchMakingSTEAM.is_server_ok
	function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_list, is_invite, ...)
		if attributes_list.numbers and attributes_list.numbers[3] < 3 then
			return false
		end
		return old_is_server_ok(self, friends_only, room, attributes_list, is_invite, ...)
	end
end