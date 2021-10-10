local ThisModPath = ModPath
local ThisSavePath = SavePath
local mod_ids = Idstring(ThisModPath):key()
local hook1 = "F"..Idstring("hook1::"..mod_ids):key()
local hook2 = "F"..Idstring("hook2::"..mod_ids):key()
local __dt1 = "F"..Idstring("__dt1::"..mod_ids):key()
local bool1 = "F"..Idstring("bool1::"..mod_ids):key()
local bool2 = "F"..Idstring("bool2::"..mod_ids):key()
local func1 = "F"..Idstring("func1::"..mod_ids):key()
local is_LLWepF = type(LLWepF) == "table" and type(LLWepF.Options) == "table" and type(LLWepF.Options.GetValue) == "function"

PlayerStandard[func1] = PlayerStandard[func1] or function(them, weap_base)
	local weapon_id = weap_base:get_name_id()
	local weapon_tweak_data = tweak_data.weapon[weapon_id]
	local __camera_base = them._camera_unit:base()
	local stance_standard = tweak_data.player.stances.default[managers.player:current_state()] or tweak_data.player.stances.default.standard
	local head_stance = them._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
	local stances = tweak_data.player.stances.default
	local misc_attribs = stances.standard
	local offset_pos = Vector3(0, 0, -20)
	local offset_rot = Rotation(50, 0, 0)
	local duration_multiplier, duration = 1, 1
	local disable_custom_wep = is_LLWepF and LLWepF.Options:GetValue("__custom_wep_disable") or false
	if is_LLWepF then
		offset_pos = Vector3(
			LLWepF.Options:GetValue("__offset_pos_x"), 
			LLWepF.Options:GetValue("__offset_pos_y"), 
			LLWepF.Options:GetValue("__offset_pos_z")
		)
		offset_rot = Rotation(
			LLWepF.Options:GetValue("__offset_rot_x"), 
			LLWepF.Options:GetValue("__offset_rot_y"), 
			LLWepF.Options:GetValue("__offset_rot_z")
		)
		duration = LLWepF.Options:GetValue("__time_speed")
	end
	if disable_custom_wep and weapon_tweak_data.custom then
		return
	end
	if type(LLWepF.AddonCfg) == "table" and #(LLWepF.AddonCfg) > 0 then
		for _, __cfg in pairs(LLWepF.AddonCfg) do
			local is_match = false
			if __cfg.weapon_id and __cfg.weapon_id == weapon_id then
				is_match = true
			elseif type(__cfg.categories) == "table" and table.contains_all(weapon_tweak_data.categories, __cfg.categories) then
				is_match = true
			elseif type(__cfg.categories) == "table" and table.contains(weapon_tweak_data.categories, __cfg.categories[1]) then
				is_match = true
			elseif type(__cfg.categories) == "string" and weapon_tweak_data.categories[1] == __cfg.categories then
				is_match = true
			end
			if is_match then
				local __pos_x = __cfg.__offset_pos_x or offset_pos.x
				local __pos_y = __cfg.__offset_pos_y or offset_pos.y
				local __pos_z = __cfg.__offset_pos_z or offset_pos.z
				offset_pos = Vector3(__pos_x, __pos_y, __pos_z)				
				local __rot_yaw = __cfg.__offset_rot_x or offset_rot:yaw()
				local __rot_pitch = __cfg.__offset_rot_y or offset_rot:pitch()
				local __rot_roll = __cfg.__offset_rot_z or offset_rot:roll()
				offset_rot = Rotation(__rot_yaw, __rot_pitch, __rot_roll)
				break
			end
		end
	end
	local new_fov = them:get_zoom_fov(misc_attribs) + 0
	__camera_base:clbk_stance_entered(
		misc_attribs.shoulders, 
		head_stance, 
		misc_attribs.vel_overshot, 
		new_fov, 
		misc_attribs.shakers, 
		{translation = offset_pos, rotation = offset_rot}, 
		duration_multiplier, 
		duration
	)
end

local function __check_is_aiming_at_enemies_or_civilians(__camera)
	local __distance = is_LLWepF and LLWepF.Options:GetValue("__uppered_wep_distance") or 1000
	if __distance <= 0 then
		return false
	end
	local __from = __camera:position()
	local __to = __from + __camera:forward() * __distance
	local __ray = World:raycast("ray", __from, __to, "slot_mask", managers.slot:get_mask("enemies", "civilians"))
	return type(__ray) == "table" and __ray.hit_position and __ray.unit or false
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", hook1, function(self, __t, __dt)
	if self._camera_unit and alive(self._camera_unit) and self._camera_unit:base() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
		local __weap_base = self._equipped_unit:base()
		local __action_forbidden = self._shooting or 
									self:_is_reloading() or 
									self:in_steelsight() or 
									self:_changing_weapon() or 
									self:_is_meleeing() or 
									self._use_item_expire_t or 
									self:_interacting() or 
									self:_is_throwing_projectile() or 
									self:_is_deploying_bipod() or 
									self._menu_closed_fire_cooldown > 0 or 
									self:is_switching_stances() or 
									self:_is_cash_inspecting() or --observing the weapon
									__check_is_aiming_at_enemies_or_civilians(self._unit:camera()) --thanks to Hoppip
		if not self[__dt1] or __action_forbidden or not __weap_base:start_shooting_allowed() then
			self[__dt1] = is_LLWepF and LLWepF.Options:GetValue("__time_delay") or 3
			if self[bool1] then
				self:_stance_entered(false)
			end
			self[bool1] = false
			self[bool2] = self[bool2] or {}
			--auto turn gadget on
			if self[bool2][self._equipped_unit:key()] then
				local __last_gadget_idx = self[bool2][self._equipped_unit:key()] or 1
				self[bool2][self._equipped_unit:key()] = nil
				__weap_base:set_gadget_on(__last_gadget_idx, false)
			end
		else
			if LLWepF.ForcedApplyToFov or (self[__dt1] <= 0 and not self[bool1]) then
				LLWepF.ForcedApplyToFov = false
				self[bool1] = true
				--auto turn gadget off
				if is_LLWepF and LLWepF.Options:GetValue("__auto_gadget_off") and __weap_base.set_gadget_on and __weap_base:has_gadget() and __weap_base:was_gadget_on() then
					self[bool2][self._equipped_unit:key()] = __weap_base:current_gadget_index() or 1
					__weap_base:gadget_off()
				end
				self[func1](self, __weap_base)
			else
				self[__dt1] = self[__dt1] - __dt
			end		
		end
	end
end)

Hooks:PostHook(PlayerStandard, "_update_check_actions", hook2, function(self, __t, __dt)
	if Utils and self._camera_unit and alive(self._camera_unit) and self._camera_unit:base() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
		local too_close_dis = is_LLWepF and LLWepF.Options:GetValue("__too_close") or 50
		if too_close_dis > 0 then
			local is_too_close = Utils:GetPlayerAimPos(managers.player:player_unit(), too_close_dis) or nil
			if is_too_close and not self[bool1] then
				LLWepF.ForcedApplyToFov = true
			end
		end
	end
end)

local function LLWepFLoadAddonCfg()
	LLWepF.AddonCfg = LLWepF.AddonCfg or {}
	local configs = file.GetFiles(ThisModPath.."/cfg/")
	if type(configs) == "table" then
		for i, cfg in pairs(configs) do
			dofile(ThisModPath.."/cfg/"..cfg)
		end
	end
	if file.DirectoryExists(ThisSavePath.."/LLWepF CFG/") then
		configs = file.GetFiles(ThisSavePath.."/LLWepF CFG/")
		if type(configs) == "table" then
			for i, cfg in pairs(configs) do
				dofile(ThisSavePath.."/LLWepF CFG/"..cfg)
			end
		end
	end
end

LLWepFLoadAddonCfg()