local ThisModPath = ModPath
local ThisSavePath = SavePath
local function __Name(__text)
	return "LLW_"..Idstring(tostring(__text)..ThisModPath):key()
end

LLWepF = LLWepF or {}

local __dt1 = __Name("__dt1")
local init1 = __Name("init1")
local init2 = __Name("init2")
local bool1 = __Name("bool1")
local bool2 = __Name("bool2")
local is_LLWepF = type(LLWepF) == "table" and type(LLWepF.Options) == "table" and type(LLWepF.Options.GetValue) == "function"

function PlayerStandard:__apply_lowered_weapon(weap_base)
	local weapon_id = weap_base:get_name_id()
	local weapon_tweak_data = tweak_data.weapon[weapon_id]
	local __camera_base = self._camera_unit:base()
	local stance_standard = tweak_data.player.stances.default[managers.player:current_state()] or tweak_data.player.stances.default.standard
	local head_stance = self._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
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
	
	else
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
		local new_fov = self:get_zoom_fov(misc_attribs) + 0
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

local __whisper_mode = __Name("__whisper_mode")

function PlayerStandard:__loop_function_1(__t, __dt)
	if self._camera_unit and alive(self._camera_unit) and self._camera_unit:base() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
		local __sprinting_disable_lowered = is_LLWepF and LLWepF.Options:GetValue("__sprinting_disable_lowered") or false
		local __assault_disable_lowered = is_LLWepF and LLWepF.Options:GetValue("__assault_disable_lowered") or false
		local is_whisper_mode = managers.groupai:state():whisper_mode()
		if __assault_disable_lowered and not is_whisper_mode then
			if (type(self[__whisper_mode]) ~= type(is_whisper_mode)) or (self[__whisper_mode] ~= is_whisper_mode) then
				self[__whisper_mode] = is_whisper_mode
				self:_stance_entered(false)
			end
			self[__dt1] = 1
		end
		local __time_delay = is_LLWepF and LLWepF.Options:GetValue("__time_delay") or 3
		if not _G.__LLWepF_Forced_to_Run and __time_delay < 0 then
			self[__dt1] = 1
		end
		--[[
			keybind to run
		]]
		if _G.__LLWepF_Forced_to_Run then
			self[__dt1] = 0
		end
		if _G.__LLWepF_ForcedApplyToFov then
			_G.__LLWepF_ForcedApplyToFov = false
			self:_stance_entered(false)
		end
		local __weap_base = self._equipped_unit:base()
		local __action_forbidden = self._shooting or 
									(self._running and __sprinting_disable_lowered) or 
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
			self[__dt1] = __time_delay
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
				PlayerStandard.__apply_lowered_weapon(self, __weap_base)
			else
				self[__dt1] = self[__dt1] - __dt
			end		
		end
		if _G.__LLWepF_Forced_to_RunStart_ReTry then
			_G.__LLWepF_Forced_to_RunStart_ReTry = _G.__LLWepF_Forced_to_RunStart_ReTry - __dt
			if _G.__LLWepF_Forced_to_RunStart_ReTry <= 0 then
				_G.__LLWepF_Forced_to_RunStart_ReTry = nil
				_G.__LLWepF_Forced_to_Run = true
			end
		end
		if _G.__LLWepF_Forced_to_RunEnd_ReTry then
			_G.__LLWepF_Forced_to_RunEnd_ReTry = _G.__LLWepF_Forced_to_RunEnd_ReTry - __dt
			if _G.__LLWepF_Forced_to_RunEnd_ReTry <= 0 then
				_G.__LLWepF_Forced_to_RunEnd_ReTry = nil
				_G.__LLWepF_Forced_to_Run = false
				_G.__LLWepF_ForcedApplyToFov = true
			end
		end
	end
end

function PlayerStandard:__loop_function_2(__t, __dt)
	if Utils and self._camera_unit and alive(self._camera_unit) and self._camera_unit:base() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
		local too_close_dis = is_LLWepF and LLWepF.Options:GetValue("__too_close") or 50
		if too_close_dis >= 0 then
			local is_too_close = Utils:GetPlayerAimPos(managers.player:player_unit(), too_close_dis) or nil
			if is_too_close and not self[bool1] then
				LLWepF.ForcedApplyToFov = true
			end
		end
	end
end

function PlayerStandard:__loop_function_3(__mover)
	if __mover == PlayerStandard.MOVER_STAND or __mover == PlayerStandard.MOVER_DUCK then
		if _G.__LLWepF_Forced_to_Run then
			_G.__LLWepF_Forced_to_RunStart_ReTry = 0.5
			_G.__LLWepF_Forced_to_Run = false
			_G.__LLWepF_ForcedApplyToFov = true
		end
		self[bool1] = false
		self[__dt1] = 1
	end
end

local function LLWepFLoadAddonCfg()
	local io_file = file
	LLWepF.AddonCfg = LLWepF.AddonCfg or {}
	local configs = io_file.GetFiles(ThisModPath.."/cfg/")
	if type(configs) == "table" then
		for i, cfg in pairs(configs) do
			dofile(ThisModPath.."/cfg/"..cfg)
		end
	end
	if io_file.DirectoryExists(ThisSavePath.."/LLWepF CFG/") then
		configs = io_file.GetFiles(ThisSavePath.."/LLWepF CFG/")
		if type(configs) == "table" then
			for i, cfg in pairs(configs) do
				dofile(ThisSavePath.."/LLWepF CFG/"..cfg)
			end
		end
	end
end

if PlayerStandard and not PlayerStandard[init1] then
	PlayerStandard[init1] = true
	
	Hooks:PostHook(PlayerStandard, "_update_check_actions", __Name("hook1"), function(self, __t, __dt)
		self:__loop_function_1(__t, __dt)
		self:__loop_function_2(__t, __dt)
	end)

	Hooks:PostHook(PlayerStandard, "_activate_mover", __Name("hook2"), function(self, __mover, ...)
		self:__loop_function_3(__mover)
	end)
end

if PlayerCarry and not PlayerCarry[init2] then
	PlayerCarry[init2] = true
	
	Hooks:PostHook(PlayerCarry, "_update_check_actions", __Name("hook3"), function(self, __t, __dt)
		PlayerStandard.__loop_function_1(self, __t, __dt)
		PlayerStandard.__loop_function_2(self, __t, __dt)
	end)

	Hooks:PostHook(PlayerCarry, "_activate_mover", __Name("hook4"), function(self, __mover, ...)
		PlayerStandard.__loop_function_3(self, __mover)
	end)
end

LLWepFLoadAddonCfg()