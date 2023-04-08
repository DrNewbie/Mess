local ThisModPath = ModPath

LegendaryArmours = LegendaryArmours or {}

local __Name = function(__id)
	return "AAA_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")

Hooks:Add("LocalizationManagerPostInit", __Name("Localization"), function(loc)
	if LegendaryArmours.nepgear then
		local add_buff = {
			"[+] When your teammates are down, regenerate back your health and armor.\n",
			"[+] For each teammate in custody, gain 100% more health and armor.\n",
			"[+] For each teammate in custody, gain 15% more speed.\n",
			"[+] Melee charge time reduced by 100% and attack speed increased by 50%.\n",
			"[+] The lower your teammates health is, the more melee damage you do.\n",
			"[-] Total ammo capacity is decreased by 100%."
		}
		local loc_file = io.open(ThisModPath.."localization.json", "r")
		if loc_file then
			add_buff = json.decode(loc_file:read("*all"))
			loc_file:close()
		end
		if type(add_buff) == "table" then
			loc:add_localized_strings({
				["bm_askn_nepgear_desc"] = loc:text("bm_askn_nepgear_desc").."\n\n"..table.concat(add_buff, "\n"),
				["bm_askn_nepgear_no_hands_desc"] = loc:text("bm_askn_nepgear_no_hands_desc").."\n\n"..table.concat(add_buff, "\n"),
				["bm_askn_nepgear_mask_desc"] = loc:text("bm_askn_nepgear_mask_desc").."\n\n"..table.concat(add_buff, "\n"),
				["bm_askn_nepgear_no_hands_mask_desc"] = loc:text("bm_askn_nepgear_no_hands_mask_desc").."\n\n"..table.concat(add_buff, "\n")
			})
		end
	end
end)

if PlayerManager and not PlayerManager[is_bool] then
	PlayerManager[is_bool] = true
	Hooks:PostHook(PlayerManager, "init_finalize", __Name("init_finalize"), function(self)
		local las = tostring(managers.blackmarket:equipped_player_style())
		if las == "las_nepgear" or las == "las_nepgear_no_hands" or las == "las_nepgear_mask" or las == "las_nepgear_no_hands_mask" then
			self._is_las_nepgear = true
		else
			self._is_las_nepgear = nil
		end
	end)

	function PlayerManager:Is_LAS_Nepgear()
		return self._is_las_nepgear
	end

	local NepgearLASBoostsSpeedBoost = PlayerManager.movement_speed_multiplier

	function PlayerManager:movement_speed_multiplier(...)
		local Ans = NepgearLASBoostsSpeedBoost(self, ...)
		if self:Is_LAS_Nepgear() and managers.trade and managers.trade:num_in_trade_queue() > 0 then
			Ans = Ans * math.pow(1.15, managers.trade:num_in_trade_queue())
		end
		return Ans
	end

	local NepgearLASBoostsArmorBoost = PlayerManager.body_armor_skill_multiplier

	function PlayerManager:body_armor_skill_multiplier(...)
		local Ans = NepgearLASBoostsArmorBoost(self, ...)
		if self:Is_LAS_Nepgear() and managers.trade and managers.trade:num_in_trade_queue() > 0 then
			Ans = Ans * math.pow(2, managers.trade:num_in_trade_queue())
		end
		return Ans
	end

	local NepgearLASBoostsHPBoost = PlayerManager.health_skill_multiplier

	function PlayerManager:health_skill_multiplier(...)
		local Ans = NepgearLASBoostsHPBoost(self, ...)
		if self:Is_LAS_Nepgear() and managers.trade and managers.trade:num_in_trade_queue() > 0 then
			Ans = Ans * math.pow(2, managers.trade:num_in_trade_queue())
		end
		return Ans
	end
end

if GroupAIStateBase and not GroupAIStateBase[is_bool] then
	GroupAIStateBase[is_bool] = true
	Hooks:PreHook(GroupAIStateBase, "report_criminal_downed", __Name("report_criminal_downed"), function(self, r_unit)
		if (r_unit:interaction() and r_unit:interaction():active()) or (r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested())) then
			if managers.player and managers.player:Is_LAS_Nepgear() and managers.player:local_player() then
				local ply_m = managers.player
				local ply_u = ply_m:local_player()
				if r_unit ~= ply_u and ply_u:character_damage() then
					ply_u:character_damage():band_aid_health()
					ply_u:character_damage():_regenerate_armor()
					if ply_m:has_active_timer("replenish_grenades") then
						ply_m:start_timer("replenish_grenades", 0.1, callback(ply_m, ply_m, "_on_grenade_cooldown_end"))
						managers.hud:set_player_grenade_cooldown({
							end_time = managers.game_play_central:get_heist_timer() + 0.1,
							duration = 0.1
						})
					end
				end
			end
		end
	end)
end

if HuskCopDamage and not HuskCopDamage[is_bool] then
	HuskCopDamage[is_bool] = true
	local old_husk_damage_melee = HuskCopDamage.damage_melee
	function HuskCopDamage:damage_melee(attack_data, ...)
		attack_data = CopDamage.NepgearLASMeleeDmgBoost(self, attack_data)
		return old_husk_damage_melee(self, attack_data, ...)
	end
end

if NewRaycastWeaponBase and not NewRaycastWeaponBase[is_bool] then
	NewRaycastWeaponBase[is_bool] = true
	Hooks:PostHook(NewRaycastWeaponBase, "replenish", __Name("replenish"), function(self)
		if managers.player and managers.player:Is_LAS_Nepgear() then
			self:set_ammo_max(0)
			self:set_ammo_max_per_clip(0)
			self:set_ammo_total(0)
			call_on_next_update(function ()
				managers.hud:set_ammo_amount(self:selection_index(), self:ammo_info())
			end)
		end
	end)
end

if PlayerStandard and not PlayerStandard[is_bool] then
	PlayerStandard[is_bool] = true
	local NepgearLASBoostsMeleeChargeSpeedBoost = PlayerStandard._get_melee_charge_lerp_value

	function PlayerStandard:_get_melee_charge_lerp_value(...)
		if managers.player and managers.player:Is_LAS_Nepgear() then
			return 1
		else
			return NepgearLASBoostsMeleeChargeSpeedBoost(self, ...)
		end
	end

	Hooks:PostHook(PlayerStandard, "_do_melee_damage", __Name("_do_melee_damage"), function(self, t, bayonet_melee, melee_hit_ray)
		if self._state_data and managers.player and managers.player:Is_LAS_Nepgear() then
			local _prec = 0.50
			local _melee_id = managers.blackmarket:equipped_melee_weapon()
			local _melee_tweak = tweak_data.blackmarket.melee_weapons[_melee_id]
			local _expire_t = _melee_tweak.expire_t or 0
			local _repeat_expire_t = _melee_tweak.repeat_expire_t or 0		
			local r_expire_t = _expire_t * _prec
			local r_repeat_expire_t = _repeat_expire_t * _prec
			if self._state_data.melee_expire_t then
				self._state_data.melee_expire_t = self._state_data.melee_expire_t - r_expire_t
			end
			if self._state_data.melee_repeat_expire_t then
				self._state_data.melee_repeat_expire_t = self._state_data.melee_repeat_expire_t - r_repeat_expire_t
			end
		end
	end)
end

if CopDamage and not CopDamage[is_bool] then
	CopDamage[is_bool] = true
	function CopDamage:NepgearLASMeleeDmgBoost(attack_data)
		if attack_data.damage and attack_data.attacker_unit and attack_data.attacker_unit == managers.player:local_player() and managers.player and managers.player:Is_LAS_Nepgear() then
			for hud_i, hud_d in pairs(managers.hud._teammate_panels) do
				if hud_d._health_data then
					local char_name = managers.criminals:character_name_by_panel_id(hud_i)
					if char_name then
						local char_unit = managers.criminals:character_unit_by_name(char_name)
						if char_unit and char_unit ~= managers.player:local_player() then
							if managers.trade:is_criminal_in_custody(char_name) then
								attack_data.damage = attack_data.damage * 1.99
							else
								if not managers.groupai:state():is_unit_team_AI(char_unit) then
									local health_max = hud_d._health_data.total
									local health_current = hud_d._health_data.current
									if type(health_max) == "number" and type(health_current) == "number" then
										local health_rate = 1 - math.max(health_current / health_max, 0.0001)
										local dmg_buff = 1 + math.min(health_rate, 0.99)
										attack_data.damage = attack_data.damage * dmg_buff
									end
								end
							end
						end
					end
				end
			end
		end
		return attack_data
	end

	local old_damage_melee = CopDamage.damage_melee

	function CopDamage:damage_melee(attack_data, ...)
		attack_data = self:NepgearLASMeleeDmgBoost(attack_data)
		return old_damage_melee(self, attack_data, ...)
	end
end