local ThisModPath = ModPath
local ThisModReqPackage = "packages/backpack_ammo_test0001"
if not PackageManager:package_exists(ThisModReqPackage) then
	return
end

local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "AB_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local __Log = function(__msg)
	--log("["..__Name("log").."]\t"..tostring(__msg))
	return
end

local BoxUnit = __Name("BoxUnit")
_G[BoxUnit] = _G[BoxUnit] or {}

local TihsModItemUnit = "units/jfr_props/jfr_props_ammos_boxes_06"
local TihsModItemUnitIds = Idstring(TihsModItemUnit)

local function __Is_Ready_to_Use()
	if PackageManager:loaded(ThisModReqPackage) and DB:has("unit", TihsModItemUnit) then
		return true
	end
	return false
end

local function __Delete_Box(u_key)
	_G[BoxUnit] = _G[BoxUnit] or {}
	if u_key then
		if _G[BoxUnit][u_key] and alive(_G[BoxUnit][u_key]) then
			_G[BoxUnit][u_key]:unlink()
			World:delete_unit(_G[BoxUnit][u_key])
		end
		_G[BoxUnit][u_key] = nil
	else
		for __k, _ in pairs(_G[BoxUnit]) do
			if _G[BoxUnit][__k] and alive(_G[BoxUnit][__k]) then
				World:delete_unit(_G[BoxUnit][__k])
			end
			_G[BoxUnit][__k] = nil
		end
	end
	return
end

local function __Spawn_and_Link_to_User(parent_unit, weapon_unit)
	if not __Is_Ready_to_Use() then
		--__Log("not __Is_Ready_to_Use")
		return
	end
	if type(parent_unit) ~= "userdata" or type(weapon_unit) ~= "userdata" then
		--__Log("not unit")
		return
	end
	if not alive(parent_unit) or not alive(weapon_unit) or not type(weapon_unit.base) == "function" or not weapon_unit:base() then
		--__Log("not alive")
		return
	end
	local parent_obj_name = Idstring("Neck")
	local parent_obj = parent_unit:get_object(parent_obj_name)
	if not parent_obj then
		--__Log("no parent_obj")
		return
	end
	local tweak_weapon = tweak_data.weapon
	local tweak_parts = tweak_weapon.factory.parts
	local wep_base = weapon_unit:base()
	local wep_name_id = wep_base.name_id
	local wep_blueprints = weapon_unit:base()._blueprint
	local __ammo_backpack_data = nil
	--__Log(wep_name_id)
	--__Log(json.encode(wep_blueprints))
	if type(wep_name_id) == "string" then
		if tweak_weapon[wep_name_id] and type(tweak_weapon[wep_name_id].__addition_ammo_backpack_data) == "table" and tweak_weapon[wep_name_id].__addition_ammo_backpack_data.is_bool then
			__ammo_backpack_data = tweak_weapon[wep_name_id].__addition_ammo_backpack_data
		end
	end
	if type(wep_blueprints) == "table" and not table.empty(wep_blueprints) then
		for _, __wd in pairs(wep_blueprints) do
			if tweak_parts[__wd] and type(tweak_parts[__wd].__addition_ammo_backpack_data) == "table" and tweak_parts[__wd].__addition_ammo_backpack_data.is_bool then
				__ammo_backpack_data = tweak_parts[__wd].__addition_ammo_backpack_data
				break
			end
		end
	end
	if not __ammo_backpack_data then
		--__Log("no __ammo_backpack_data")
		return
	end
	local s_unit = World:spawn_unit(TihsModItemUnitIds, parent_unit:position())
	if s_unit then
		__Delete_Box(parent_unit:key())
		__ammo_backpack_data.pos_fix = __ammo_backpack_data.pos_fix or function(__p_obj, __p_obj_rot)
			return __p_obj:position() - __p_obj_rot:x() * 10 - __p_obj_rot:y() * 20 - __p_obj_rot:z() * 10
		end
		__ammo_backpack_data.rot_fix = __ammo_backpack_data.rot_fix or function(__p_obj, __p_obj_rot)
			return Rotation(__p_obj_rot:x(), -__p_obj_rot:z())
		end
		parent_unit:link(parent_obj_name, s_unit)
		local parent_obj_rot = parent_obj:rotation()
		local world_pos = __ammo_backpack_data.pos_fix(parent_obj, parent_obj_rot)
		local world_rot = __ammo_backpack_data.rot_fix(parent_obj, parent_obj_rot)
		s_unit:set_position(world_pos)
		s_unit:set_rotation(world_rot)
		_G[BoxUnit][parent_unit:key()] = s_unit
		return s_unit
	end
	return
end

if MenuSceneManager and string.lower(tostring(RequiredScript)) == "lib/managers/menu/menuscenemanager" then
	Hooks:PostHook(MenuSceneManager, "_set_character_equipment", __Name("_set_character_equipment"), function(self)
		local function __p()
			if __Is_Ready_to_Use() and type(self._weapon_units) == "table" then
				local __units = {self._character_unit}
				if type(self._henchmen_characters) == "table" then
					for _, __henunit in pairs(self._henchmen_characters) do
						table.insert(__units, __henunit)
					end
				end
				for _, __unit in pairs(__units) do
					if type(__unit) == "userdata" and type(self._weapon_units[__unit:key()]) == "table" then
						local __primary = self._weapon_units[__unit:key()]["primary"]			
						if type(__primary) == "table" and type(__primary.unit) == "userdata" then
							__Delete_Box()
							__Spawn_and_Link_to_User(__unit, __primary.unit)
						end
					end
				end
			end
		end
		DelayedCalls:Add(__Name("DelayedCalls::1s"), 1, function()
			__p()
		end)
		DelayedCalls:Add(__Name("DelayedCalls::5s"), 5, function()
			__p()
		end)
		DelayedCalls:Add(__Name("DelayedCalls::7s"), 9, function()
			__p()
		end)
	end)
	Hooks:PreHook(MenuSceneManager, "destroy", __Name("destroy"), function(self)
		__Delete_Box()
	end)
end

if WeaponTweakData and string.lower(tostring(RequiredScript)) == "lib/tweak_data/weapontweakdata" then
	Hooks:PostHook(WeaponTweakData, "_init_hk51b", __Name("_init_hk51b"), function(self)
		self.hk51b.__addition_ammo_backpack_data = self.hk51b.__addition_ammo_backpack_data or {is_bool = true}
	end)
	Hooks:PostHook(WeaponTweakData, "_init_data_hk51b_crew", __Name("_init_data_hk51b_crew"), function(self)
		self.hk51b_crew.__addition_ammo_backpack_data = self.hk51b.__addition_ammo_backpack_data or {is_bool = true}
	end)
end

local __dt = __Name("update::dt")

if TeamAIMovement and string.lower(tostring(RequiredScript)) == "lib/units/player_team/teamaimovement" then
	Hooks:PostHook(TeamAIMovement, "update", __Name("TeamAIMovement:update"), function(self)
		self[__dt] = self[__dt] or 0
		if TimerManager:game():time() > self[__dt] then
			self[__dt] = TimerManager:game():time() + 10
			__Spawn_and_Link_to_User(self._unit, self._unit:inventory():equipped_unit())
		end
	end)
	Hooks:PreHook(TeamAIMovement, "pre_destroy", __Name("TeamAIMovement:pre_destroy"), function(self)
		__Delete_Box(self._unit)
	end)
end

if HuskTeamAIMovement and string.lower(tostring(RequiredScript)) == "lib/units/player_team/huskteamaimovement" then
	Hooks:PostHook(HuskTeamAIMovement, "update", __Name("HuskTeamAIMovement:update"), function(self)
		self[__dt] = self[__dt] or 0
		if TimerManager:game():time() > self[__dt] then
			self[__dt] = TimerManager:game():time() + 10
			__Spawn_and_Link_to_User(self._unit, self._unit:inventory():equipped_unit())
		end
	end)
	Hooks:PreHook(HuskTeamAIMovement, "pre_destroy", __Name("HuskTeamAIMovement:pre_destroy"), function(self)
		__Delete_Box(self._unit)
	end)
end

if not PackageManager:loaded(ThisModReqPackage) then
	PackageManager:load(ThisModReqPackage)
end