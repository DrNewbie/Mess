local ThisModPath = ModPath

local __Name = function(__id)
	return "SLOW_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

local is_bool = __Name("is_bool")
local is_init = __Name("is_init")

local dt = __Name("dt")

local char_power = __Name("char_power")
local heavy_now = __Name("heavy_now")

local projectile_weight = "__ssslow_projectile_weight"	-- projectile weight
local ammo_weight = "__ssslow_ammo_weight"	-- ammo weight

local default = {
	character = {
		weight100 = 100
	},
	projectile = {
		base_projectile = "frag",
		base_projectile_weight = 20
	},
	ammo = {
		ammo_weight = 1
	},
	weapon = {
		base_weapon_weight = 33
	}
}

local function get_char_power(__unit)
	if not __unit or not alive(__unit) then
		return
	end
	--[[
		TODO: later
	]]
	return
end

--[[
	Additional slow based on weapon size
		by Hoppip
]]
local function get_weapon_weight_now(__unit)
	if __unit and alive(__unit) and __unit.base and __unit:base() then
		local them = __unit:base()
		local total_volume = 0
		for part_id, part in pairs(them._parts) do
			local oobb_size = alive(part.unit) and part.unit:oobb():size()
			if oobb_size then
				total_volume = total_volume + math.max(0, oobb_size.x) * math.max(0, oobb_size.y) * math.max(0, oobb_size.z)
			end
		end
		local volume_scaled = total_volume ^ (1 / 3)
		local volume_adjusted = math.clamp((volume_scaled - 15) / 40, 0, 1)
		return math.lerp(1, 0.5, volume_adjusted)
	end
	return 0
end

local weapo_weight_data = {}

local function get_ammo_weight_now(__unit)
	if not __unit or not alive(__unit) or type(__unit.inventory) ~= "function" or not __unit:inventory() then
		return -1
	end
	local __inventory = __unit:inventory():available_selections()
	if type(__inventory) ~= "table" or not next(__inventory) then
		return -2
	end
	local how_heavy_now = 0.000001
	for _, __weapon in pairs(__inventory) do
		if __weapon.unit and alive(__weapon.unit) and type(__weapon.unit.base) == "function" and __weapon.unit:base() then
			local __weapon_key = __weapon.unit:key()
			local __weapon_base = __weapon.unit:base()
			local __weapon_tweak = __weapon_base:weapon_tweak_data()
			--[[
				weight calculator
			]]
			if type(__weapon_tweak) == "table" then
				local __ammo_total = __weapon_base:get_ammo_total()
				if type(__ammo_total) ~= "number" or __ammo_total < 0 then
					__ammo_total = 0
				end
				local __projectile_types = __weapon_tweak.projectile_types or nil
				if __projectile_types and type(tweak_data.projectiles[__projectile_types]) == "table" then
					--[[
						get projectile weight
					]]
					if type(tweak_data.projectiles[__projectile_types][projectile_weight]) == "number" then
						how_heavy_now = how_heavy_now + tweak_data.projectiles[__projectile_types][projectile_weight] * __ammo_total
					else
						local this_damage = tweak_data.projectiles[__projectile_types].damage or 1
						local frag_damage = tweak_data.projectiles[default.projectile.base_projectile] and tweak_data.projectiles[default.projectile.base_projectile].damage or 1
						local damage_mul = this_damage / frag_damage
						how_heavy_now = how_heavy_now + default.projectile.base_projectile_weight * damage_mul * __ammo_total
					end
				else
					--[[
						get ammo weight
					]]
					if type(__weapon_tweak[ammo_weight]) == "number" then
						how_heavy_now = how_heavy_now + __weapon_tweak[ammo_weight] * __ammo_total
					else
						how_heavy_now = how_heavy_now + default.ammo.ammo_weight * __ammo_total
					end
				end
				--[[
					weapon weight mul
				]]
				local __weapon_weight_mul = 0
				if type(weapo_weight_data[__weapon_key]) ~= "number" then
					__weapon_weight_mul = get_weapon_weight_now(__weapon.unit)
					weapo_weight_data[__weapon_key] = 1 - __weapon_weight_mul
				else
					__weapon_weight_mul = weapo_weight_data[__weapon_key]
				end
				if type(__weapon_weight_mul) == "number" then
					how_heavy_now = how_heavy_now + default.weapon.base_weapon_weight * __weapon_weight_mul
				end
			end
		end
	end
	return how_heavy_now
end

if PlayerManager and not PlayerManager[is_bool] then
	function PlayerManager:__ssslow_refresh()
		self[dt] = 1.5
		if self:local_player() then
			local player_unit = self:local_player()
			local this_how_heavy_now = get_ammo_weight_now(player_unit)
			if this_how_heavy_now > 0 then
				self[heavy_now] = tonumber(this_how_heavy_now)
			else
				self[heavy_now] = 0
			end
		end
		return self[heavy_now]
	end
	
	function PlayerManager:__ssslow_ratio_now()
		if self[is_init] and self:local_player() then
			local this_how_heavy_now = 0
			if not self[heavy_now] then
				self[heavy_now] = 0
				self:__ssslow_refresh()
			end
			this_how_heavy_now = tonumber(self[heavy_now])
			if this_how_heavy_now > 0 then
				return this_how_heavy_now / default.character.weight100
			end
		end
		return 1
	end
	
	Hooks:PostHook(PlayerManager, "init_finalize", __Name("init_finalize"), function(self, ...)
		self[heavy_now] = 0
		self[char_power] = default.character
		self:unregister_message(Message.OnWeaponFired, __Name("OnWeaponFired"))
		self:register_message(Message.OnWeaponFired, __Name("OnWeaponFired"), callback(self, self, "__ssslow_refresh"))
		self:unregister_message(Message.OnAmmoPickup, __Name("OnAmmoPickup"))
		self:register_message(Message.OnAmmoPickup, __Name("OnAmmoPickup"), callback(self, self, "__ssslow_refresh"))
		self:unregister_message(Message.OnSwitchWeapon, __Name("OnSwitchWeapon"))
		self:register_message(Message.OnSwitchWeapon, __Name("OnSwitchWeapon"), callback(self, self, "__ssslow_refresh"))
		self:unregister_message(Message.OnPlayerReload, __Name("OnPlayerReload"))
		self:register_message(Message.OnPlayerReload, __Name("OnPlayerReload"), callback(self, self, "__ssslow_refresh"))
		self:__ssslow_refresh()
	end)
	
	Hooks:PostHook(PlayerManager, "update", __Name("update"), function(self, t, dt, ...)
		if self:local_player() and not self[is_init] and self:__ssslow_refresh() > 0 then
			self[is_init] = true
		end
		if self:local_player() and self[is_init] then 
			if not self[dt] or self[dt] < 0 then
				self[dt] = 1.5
				self:__ssslow_refresh()
			else
				self[dt] = self[dt] - dt
			end
		end
	end)
	
	local old1 = PlayerManager.movement_speed_multiplier
	function PlayerManager:movement_speed_multiplier(...)
		local __ans = old1(self, ...)
		local __ssslow_ratio_now = self:__ssslow_ratio_now()
		__ssslow_ratio_now = 1 / __ssslow_ratio_now
		return __ans * math.clamp(__ssslow_ratio_now, 0.0001, 1)
	end
	
	local old2 = PlayerManager.upgrade_value
	function PlayerManager:upgrade_value(category, upgrade, ...)
		if category and upgrade and category == "weapon" and upgrade == "passive_reload_speed_multiplier" then
			local __ans = old2(self, category, upgrade, ...)
			local __ssslow_ratio_now = self:__ssslow_ratio_now()
			__ssslow_ratio_now = 1 / __ssslow_ratio_now
			return __ans * math.clamp(__ssslow_ratio_now, 0.0001, 1)
		end
		return old2(self, category, upgrade, ...)
	end
end