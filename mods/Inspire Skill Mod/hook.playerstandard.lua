local old_func = "F_"..Idstring("old_func::Inspire Skill Mod"):key()
local sp_dt = "DT_"..Idstring("DT::Inspire Skill Mod"):key()
local sp_max = "MAX_"..Idstring("MAX::Inspire Skill Mod"):key()
local sp_now = "NOW_"..Idstring("NOW::Inspire Skill Mod"):key()
local sp_cpr = "CPR_"..Idstring("CPR::Inspire Skill Mod"):key()
local sp_tmp = "TMP_"..Idstring("TMP::Inspire Skill Mod"):key()

Hooks:PostHook(PlayerStandard, "init", "InspireSkillModInitHelp", function(self)
	if managers.player:has_category_upgrade("player", "long_dis_revive_mod") then
		self[sp_max] = 5
		self[sp_now] = self[sp_max]
		self[sp_dt] = 0
		self[sp_tmp] = 0
	end
	if managers.player:has_category_upgrade("player", "cpr_this_crew") then
		self[sp_cpr] = managers.player:upgrade_value("player", "cpr_this_crew")
		if type(self[sp_cpr]) ~= "number" then
			self[sp_cpr] = 0.75
		end	
	end
end)

Hooks:PreHook(PlayerStandard, "_start_action_intimidate", "InspireSkillModPreHelp", function(self, t)
	if managers.player:has_category_upgrade("player", "long_dis_revive_mod") then
		if self[sp_now] <= 0 then
			--No more Inspire(long_dis_revive)
			managers.player:disable_cooldown_upgrade("cooldown", "long_dis_revive")
		else
			Aim_Pos = Utils:GetPlayerAimPos(managers.player:local_player(), 10000)
			if tostring(Aim_Pos):find("Vector3") then
				local from = self._unit:movement():m_head_pos()
				col_ray = self._unit:raycast("ray", from, Aim_Pos, "slot_mask", self._slotmask_long_distance_interaction, "sphere_cast_radius", sphere_cast_radius)
				if not col_ray or not alive(col_ray.unit) or not managers.groupai:state():all_char_criminals()[col_ray.unit:key()] then
					self[sp_tmp] = t
					managers.player:disable_cooldown_upgrade("cooldown", "long_dis_revive")
				end
			end
			if managers.player:has_enabled_cooldown_upgrade("cooldown", "long_dis_revive") then
				self[sp_dt] = t
			end
		end
	end
end)

Hooks:PostHook(PlayerStandard, "_start_action_intimidate", "InspireSkillModPostHelp", function(self, t)
	if managers.player:has_category_upgrade("player", "long_dis_revive_mod") then
		if not managers.player:has_enabled_cooldown_upgrade("cooldown", "long_dis_revive") then
			if self[sp_dt] > 0 and math.abs(t - self[sp_dt]) < 1 then
				self[sp_dt] = 0
				self[sp_now] = self[sp_now] - 1
			end
			if self[sp_tmp] > 0 and math.abs(t - self[sp_tmp]) < 1 then
				self[sp_tmp] = 0
			end
		end
	end
end)

Hooks:PreHook(PlayerStandard, "_do_melee_damage", "InspireSkillModCPR", function(self, t, bayonet_melee, melee_hit_ray, melee_entry, hand_id)
	if managers.player:has_category_upgrade("player", "cpr_this_crew") then
		melee_entry = melee_entry or managers.blackmarket:equipped_melee_weapon()
		local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
		local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0
		local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)
		local sphere_cast_radius = 20
		local col_ray = nil
		if melee_hit_ray then
			col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
		else
			local range = tweak_data.blackmarket.melee_weapons[melee_entry].stats.range or 175
			local from = self._unit:movement():m_head_pos()
			local to = from + self._unit:movement():m_head_rot():y() * range
			col_ray = self._unit:raycast("ray", from, to, "slot_mask", self._slotmask_long_distance_interaction, "sphere_cast_radius", sphere_cast_radius)
		end
		if self[sp_cpr] > math.random() and col_ray and alive(col_ray.unit) and managers.groupai:state():all_char_criminals()[col_ray.unit:key()] then
			r_unit = col_ray.unit
			if r_unit:interaction() then
				if r_unit:interaction():active() then
					r_unit:interaction():interact(r_unit)
				end
			elseif r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested()) then
				r_unit:character_damage():revive(r_unit)
			end
			return
		end
	end
end)