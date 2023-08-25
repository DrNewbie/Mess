local ThisModPath = ModPath
local ThisSavePath = SavePath
local function __Name(__text)
	return "LLW_"..Idstring(tostring(__text)..ThisModPath):key()
end

local __dt1 = __Name("__dt1")
local init1 = __Name("init1")
local init2 = __Name("init2")
local bool1 = __Name("bool1")
local bool2 = __Name("bool2")
local is_LLWepF = type(LLWepF) == "table" and type(LLWepF.Options) == "table" and type(LLWepF.Options.GetValue) == "function"

local function __apply_lowered_weapon(them, weap_base)
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
		return them
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
	return them
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

local function __loop_function_1(them, __t, __dt)
	if them._camera_unit and alive(them._camera_unit) and them._camera_unit:base() and them._equipped_unit and alive(them._equipped_unit) and them._equipped_unit:base() then
		local __sprinting_disable_lowered = is_LLWepF and LLWepF.Options:GetValue("__sprinting_disable_lowered") or false
		local __assault_disable_lowered = is_LLWepF and LLWepF.Options:GetValue("__assault_disable_lowered") or false
		local is_whisper_mode = managers.groupai:state():whisper_mode()
		if __assault_disable_lowered and not is_whisper_mode then
			if (type(them[__whisper_mode]) ~= type(is_whisper_mode)) or (them[__whisper_mode] ~= is_whisper_mode) then
				them[__whisper_mode] = is_whisper_mode
				them:_stance_entered(false)
			end
			them[__dt1] = 1
		end
		local __weap_base = them._equipped_unit:base()
		local __action_forbidden = them._shooting or 
									(them._running and __sprinting_disable_lowered) or 
									them:_is_reloading() or 
									them:in_steelsight() or 
									them:_changing_weapon() or 
									them:_is_meleeing() or 
									them._use_item_expire_t or 
									them:_interacting() or 
									them:_is_throwing_projectile() or 
									them:_is_deploying_bipod() or 
									them._menu_closed_fire_cooldown > 0 or 
									them:is_switching_stances() or 
									them:_is_cash_inspecting() or --observing the weapon
									__check_is_aiming_at_enemies_or_civilians(them._unit:camera()) --thanks to Hoppip
		if not them[__dt1] or __action_forbidden or not __weap_base:start_shooting_allowed() then
			them[__dt1] = is_LLWepF and LLWepF.Options:GetValue("__time_delay") or 3
			if them[bool1] then
				them:_stance_entered(false)
			end
			them[bool1] = false
			them[bool2] = them[bool2] or {}
			--auto turn gadget on
			if them[bool2][them._equipped_unit:key()] then
				local __last_gadget_idx = them[bool2][them._equipped_unit:key()] or 1
				them[bool2][them._equipped_unit:key()] = nil
				__weap_base:set_gadget_on(__last_gadget_idx, false)
			end
		else
			if LLWepF.ForcedApplyToFov or (them[__dt1] <= 0 and not them[bool1]) then
				LLWepF.ForcedApplyToFov = false
				them[bool1] = true
				--auto turn gadget off
				if is_LLWepF and LLWepF.Options:GetValue("__auto_gadget_off") and __weap_base.set_gadget_on and __weap_base:has_gadget() and __weap_base:was_gadget_on() then
					them[bool2][them._equipped_unit:key()] = __weap_base:current_gadget_index() or 1
					__weap_base:gadget_off()
				end
				them = __apply_lowered_weapon(them, __weap_base)
			else
				them[__dt1] = them[__dt1] - __dt
			end		
		end
	end
	return them
end

local function __loop_function_2(them, __t, __dt)
	if Utils and them._camera_unit and alive(them._camera_unit) and them._camera_unit:base() and them._equipped_unit and alive(them._equipped_unit) and them._equipped_unit:base() then
		local too_close_dis = is_LLWepF and LLWepF.Options:GetValue("__too_close") or 50
		if too_close_dis > 0 then
			local is_too_close = Utils:GetPlayerAimPos(managers.player:player_unit(), too_close_dis) or nil
			if is_too_close and not them[bool1] then
				LLWepF.ForcedApplyToFov = true
			end
		end
	end
	return them
end

local function __loop_function_3(them, __mover)
	if __mover == PlayerStandard.MOVER_STAND or __mover == PlayerStandard.MOVER_DUCK then
		them[bool1] = false
		them[__dt1] = 1
	end
	return them
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
		self = __loop_function_1(self, __t, __dt)
		self = __loop_function_2(self, __t, __dt)
	end)

	Hooks:PostHook(PlayerStandard, "_activate_mover", __Name("hook2"), function(self, __mover, ...)
		self = __loop_function_3(self, __mover)
	end)
end

if PlayerCarry and not PlayerCarry[init2] then
	PlayerCarry[init2] = true
	
	Hooks:PostHook(PlayerCarry, "_update_check_actions", __Name("hook3"), function(self, __t, __dt)
		self = __loop_function_1(self, __t, __dt)
		self = __loop_function_2(self, __t, __dt)
	end)

	Hooks:PostHook(PlayerCarry, "_activate_mover", __Name("hook4"), function(self, __mover, ...)
		self = __loop_function_3(self, __mover)
	end)
end

LLWepFLoadAddonCfg()