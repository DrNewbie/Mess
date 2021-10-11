local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "F_"..Idstring("Hook2::"..ThisModIds):key()
local Hook3 = "F_"..Idstring("Hook3::"..ThisModIds):key()
local __Dt1 = "F_"..Idstring("__Dt1::"..ThisModIds):key()
local Table1 = "F_"..Idstring("Table1::"..ThisModIds):key()
local Value1 = "F_"..Idstring("Value1::"..ThisModIds):key()
local AllowMeleeID = {
	["zeus"] = true
}

local function __despawn_effect(them)
	if type(them[Table1]) == "table" then
		for k, v in pairs(them[Table1]) do
			World:effect_manager():fade_kill(v)
			them[Table1][k] = nil
		end
	end
	them[Table1] = {}
	return
end

local function __spawn_effect(them, attach, num)
	if attach and alive(attach) and attach.orientation_object and attach:orientation_object() then
		them[Table1] = them[Table1] or {}
		for i = 1, num do
			table.insert(them[Table1], World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/character/taser_thread"),
				parent = attach:orientation_object()
			}))
		end
	end
	return
end

local function __increase_effect(them, __time)
	if type(them[Table1]) == "table" then
		for k, v in pairs(them[Table1]) do
			World:effect_manager():set_remaining_lifetime(v, __time)
		end
	end
	return
end

Hooks:PostHook(FPCameraPlayerBase, "spawn_melee_item", Hook1, function(self)
	self[Value1] = {}
	self[__Dt1] = nil
	__despawn_effect(self)
end)

Hooks:PostHook(FPCameraPlayerBase, "unspawn_melee_item", Hook2, function(self)
	self[Value1] = {}
	self[__Dt1] = nil
	__despawn_effect(self)
end)

Hooks:PostHook(FPCameraPlayerBase, "update", Hook3, function(self, __unit, __t, __dt)
	if self._melee_item_units then
		local __melee_id = managers.blackmarket:equipped_melee_weapon()
		if __melee_id and AllowMeleeID[__melee_id] then
			if not self[__Dt1] then
				self[__Dt1] = true
				for __k, __melee_unit in pairs(self._melee_item_units) do
					local __state_data = managers.player:player_unit():movement():current_state()._state_data
					if type(__state_data) == "table" and type(__state_data.melee_start_t) == "number" then
						local __max_charge_time = tweak_data.blackmarket.melee_weapons[__melee_id].stats.charge_time
						__max_charge_time = __max_charge_time * 3 or 3
						local __charge_value = math.clamp(__t - __state_data.melee_start_t, 0, __max_charge_time) / __max_charge_time
						local __effect_nums = math.max(math.round((__charge_value * 100) / 10), 1)
						self[Value1] = self[Value1] or {}
						self[Value1][__k] = self[Value1][__k] or 0
						if self[Value1][__k] ~= __effect_nums then
							self[Value1][__k] = __effect_nums
							__spawn_effect(self, __melee_unit, __effect_nums)
						else
							__increase_effect(self, 1.5)
						end
					end
				end
			else
				self[__Dt1] = false
			end
		end
	end
end)