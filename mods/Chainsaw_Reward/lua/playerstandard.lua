local Ply_init_Run_Bonus_Cut_Melee = false

Hooks:PostHook(PlayerStandard, "init", "Run_Bonus_Cut_Melee_Init", function(self)
	if Input and Input:keyboard() and not Ply_init_Run_Bonus_Cut_Melee then
		Ply_init_Run_Bonus_Cut_Melee = true
		self._Bonus_Cut_Melee_Times = 3
	end
	local unit_name = Idstring(tweak_data.blackmarket.melee_weapons.cs.unit)
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
	unit_name = Idstring(tweak_data.blackmarket.melee_weapons.cs.third_unit)
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)

function PlayerStandard:_is_Bonus_Cut_Melee()
	if self._remove_fake_equipped_melee_weapon or managers.blackmarket._fake_equipped_melee_weapon then
		return true
	end
	return false
end

function PlayerStandard:Run_Bonus_Cut_Melee()
	local t = TimerManager:game():time()
	if self._Bonus_Cut_Melee_Times < 0 or self:_is_Bonus_Cut_Melee() or self:_changing_weapon() or self:_is_reloading() or self:_interacting() or self:_is_meleeing() or self._use_item_expire_t or self:_is_throwing_projectile() or self:_on_zipline() or self:on_ladder() then
		return self:_check_action_melee(t, {btn_melee_release = true})
	end	
	managers.blackmarket:apply_fake_equipped_melee_weapon("cs")
end

Hooks:PostHook(PlayerStandard, "update", "Run_Bonus_Cut_Melee_Init", function(self, t, dt)
	if managers.blackmarket._fake_equipped_melee_weapon then
		if self._remove_fake_equipped_melee_weapon then
			self._remove_fake_equipped_melee_weapon = self._remove_fake_equipped_melee_weapon - dt
			if self._remove_fake_equipped_melee_weapon <= 0 then
				managers.blackmarket:apply_fake_equipped_melee_weapon()
				self._remove_fake_equipped_melee_weapon = nil
			end
		else
			self._remove_fake_equipped_melee_weapon = 3
			self:_start_action_melee(t, {btn_melee_release = true})
			self:discharge_melee()
			local col_ray = self:_calc_melee_hit_ray(t, 20)
			if self:_is_Bonus_Cut_Melee() and col_ray and col_ray.unit and alive(col_ray.unit) and managers.enemy:is_enemy(col_ray.unit) then
				local hit_unit = col_ray.unit				
				
				self._unit:sound():_play("1dc0cd801b7b93eb_001")
				hit_unit:sound():_play("1dc0cd801b7b93eb_001")
				
				local melee_entry = "cs"
				local state = self._ext_camera:play_redirect(self:get_animation("melee_attack"))
				local anim_attack_vars = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_vars
				self._melee_attack_var = anim_attack_vars and math.random(#anim_attack_vars)
				self:_play_melee_sound(melee_entry, "hit_air", self._melee_attack_var)
				local melee_item_tweak_anim = "attack"
				local melee_item_prefix = ""
				local melee_item_suffix = ""
				local anim_attack_param = anim_attack_vars and anim_attack_vars[self._melee_attack_var]
				if anim_attack_param then
					self._camera_unit:anim_state_machine():set_parameter(state, anim_attack_param, 1)
					melee_item_prefix = anim_attack_param .. "_"
				end
				if self._state_data.melee_hit_ray and self._state_data.melee_hit_ray ~= true then
					self._camera_unit:anim_state_machine():set_parameter(state, "hit", 1)
					melee_item_suffix = "_hit"
				end
				melee_item_tweak_anim = melee_item_prefix .. melee_item_tweak_anim .. melee_item_suffix
				self._camera_unit:base():play_anim_melee_item(melee_item_tweak_anim)
				if hit_unit:character_damage() then
					local hit_sfx = "hit_body"
					if hit_unit:character_damage() and hit_unit:character_damage().melee_hit_sfx then
						hit_sfx = hit_unit:character_damage():melee_hit_sfx()
					end
					self:_play_melee_sound(melee_entry, hit_sfx, self._melee_attack_var)
					self._camera_unit:base():play_anim_melee_item("hit_body")
				end
				local character_unit, shield_knock = nil
				local can_shield_knock = true
				if can_shield_knock and hit_unit:in_slot(8) and alive(hit_unit:parent()) and not hit_unit:parent():character_damage():is_immune_to_shield_knockback() then
					shield_knock = true
					character_unit = hit_unit:parent()
				end
				character_unit = character_unit or hit_unit
				if character_unit:character_damage() and character_unit:character_damage().damage_melee then
					local damage, damage_effect = managers.blackmarket:equipped_melee_weapon_damage_info(1)
					local action_data = {variant = "melee"}
					action_data.damage = 999999
					action_data.damage_effect = damage_effect
					action_data.attacker_unit = self._unit
					action_data.col_ray = col_ray
					action_data.name_id = melee_entry
					action_data.charge_lerp_value = 1
					local defense_data = character_unit:character_damage():damage_melee(action_data)
					self:_perform_sync_melee_damage(hit_unit, col_ray, action_data.damage)					
				end
				self._unit:character_damage():band_aid_health()
				self._unit:character_damage():_regenerate_armor()
				local inventory = self._unit:inventory()
				if inventory then
					for _, weapon in pairs(inventory:available_selections()) do
						weapon.unit:base():add_ammo_from_bag(1)
					end
				end		
				while true do
					local timer = managers.player:get_timer("replenish_grenades")
					if timer then
						managers.player:speed_up_grenade_cooldown(timer + 1)
					else
						break
					end
				end
				self._Bonus_Cut_Melee_Times = self._Bonus_Cut_Melee_Times - 1
			end
		end
	end
end)

local Bonus_Cut_Melee_Lock_1 = PlayerStandard._check_action_melee

function PlayerStandard:_check_action_melee(...)
	if self:_is_Bonus_Cut_Melee() then
		return
	end
	return Bonus_Cut_Melee_Lock_1(self, ...)
end

local Bonus_Cut_Melee_Lock_2 = PlayerStandard._is_meleeing

function PlayerStandard:_is_meleeing(...)
	if self:_is_Bonus_Cut_Melee() then
		return true
	end
	return Bonus_Cut_Melee_Lock_2(self, ...)
end