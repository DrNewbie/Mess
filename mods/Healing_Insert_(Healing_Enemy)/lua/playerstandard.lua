local Ply_init_Run_Healing_Insert_Melee = false
local __Melee_Weapon_ID = "fear"

Hooks:PostHook(PlayerStandard, "init", "Run_Healing_Insert_Melee_Init", function(self)
	if Input and Input:keyboard() and not Ply_init_Run_Healing_Insert_Melee then
		Ply_init_Run_Healing_Insert_Melee = true
		self.__Healing_Insert_Melee_dt = 0
		self.__Healing_Insert_Melee_cd = 10
	end
	local unit_name = Idstring(tweak_data.blackmarket.melee_weapons[__Melee_Weapon_ID].unit)
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
	unit_name = Idstring(tweak_data.blackmarket.melee_weapons[__Melee_Weapon_ID].third_unit)
	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)

function PlayerStandard:_is_Healing_Insert_Melee()
	if self._remove_fake_equipped_melee_weapon or managers.blackmarket._fake_equipped_melee_weapon then
		return true
	end
	return false
end

function PlayerStandard:Run_Healing_Insert_Melee()
	local t = TimerManager:game():time()
	if t < self.__Healing_Insert_Melee_dt or self:_is_Healing_Insert_Melee() or self:_changing_weapon() or self:_is_reloading() or self:_interacting() or self:_is_meleeing() or self._use_item_expire_t or self:_is_throwing_projectile() or self:_on_zipline() or self:on_ladder() then
		return self:_check_action_melee(t, {btn_melee_release = true})
	end	
	managers.blackmarket:apply_fake_equipped_melee_weapon(__Melee_Weapon_ID)
end

Hooks:PostHook(PlayerStandard, "update", "Run_Healing_Insert_Melee_Init", function(self, t, dt)
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
			if self:_is_Healing_Insert_Melee() and col_ray and col_ray.unit and alive(col_ray.unit) and managers.enemy:is_enemy(col_ray.unit) then
				local hit_unit = col_ray.unit
				
				self._unit:sound():play("pickup_fak_skill")
				
				local melee_entry = __Melee_Weapon_ID
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
				if character_unit:character_damage() and character_unit:character_damage()._send_bullet_attack_result then				
					local damage_ex = character_unit:character_damage()
					local __heal = damage_ex._HEALTH_INIT * 2
					damage_ex._health = math.min(damage_ex._health + math.abs(__heal), damage_ex._HEALTH_INIT)
					damage_ex._health_ratio = damage_ex._health_ratio / damage_ex._HEALTH_INIT
					damage_ex:_send_bullet_attack_result({}, self._unit, -0.1, CopDamage.BODY_INDEX_MAX, 0, 3)
					if character_unit:contour() then
						character_unit:contour():add("medic_heal", true)
						character_unit:contour():flash("medic_heal", 0.2)
					end
				end
				self.__Healing_Insert_Melee_dt = t + self.__Healing_Insert_Melee_cd
			end
		end
	end
end)

local Healing_Insert_Melee_Lock_1 = PlayerStandard._check_action_melee

function PlayerStandard:_check_action_melee(...)
	if self:_is_Healing_Insert_Melee() then
		return
	end
	return Healing_Insert_Melee_Lock_1(self, ...)
end

local Healing_Insert_Melee_Lock_2 = PlayerStandard._is_meleeing

function PlayerStandard:_is_meleeing(...)
	if self:_is_Healing_Insert_Melee() then
		return true
	end
	return Healing_Insert_Melee_Lock_2(self, ...)
end