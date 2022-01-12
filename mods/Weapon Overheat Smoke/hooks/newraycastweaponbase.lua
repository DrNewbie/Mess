local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "H_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "H_"..Idstring("Hook2::"..ThisModIds):key()
local Hook3 = "H_"..Idstring("Hook3::"..ThisModIds):key()
local Bool1 = "B_"..Idstring("Bool1::"..ThisModIds):key()
local Unit1 = "U_"..Idstring("Unit1::"..ThisModIds):key()
local Unit2 = "U_"..Idstring("Unit2::"..ThisModIds):key()
local Unit3 = "U_"..Idstring("Unit3::"..ThisModIds):key()
local Rate1 = "R_"..Idstring("Rate1::"..ThisModIds):key()
local Rate2 = "R_"..Idstring("Rate2::"..ThisModIds):key()

if NewRaycastWeaponBase then
	Hooks:PostHook(NewRaycastWeaponBase, "_update_stats_values", Hook1, function(self)
		if not self[Bool1] and table.contains(self._blueprint, "wpn_fps_upg_ns_shot_shark") then
			self[Bool1] = true
			local __part = managers.weapon_factory:get_part_from_weapon_by_type("barrel_ext", self._parts)
			if __part and __part.unit and alive(__part.unit) and __part.unit:get_object(Idstring("g_shark")) then
				self[Unit2] = __part.unit
				self[Unit3] = __part.unit:effect_spawner(Idstring("effect_to_spawn_001"))
			end
			self[Rate1] = 0
			self[Rate2] = 0
		end
	end)
	Hooks:PostHook(NewRaycastWeaponBase, "fire", Hook2, function(self)
		if self[Bool1] and self[Unit2] then
			self[Rate1] = self[Rate1] or 0
			self[Rate1] = self[Rate1] + math.random()*5
			self[Rate2] = 5
		end
	end)
end

if PlayerStandard then
	Hooks:PostHook(PlayerStandard, "_update_check_actions", Hook3, function(self, t, dt)
		if self._ext_inventory and self._ext_inventory:equipped_unit() then
			local them = self._ext_inventory:equipped_unit():base()
			if them and them[Unit2] and them[Unit3] and type(them[Rate2]) == "number" then
				if them[Rate2] > 0 then
					them[Rate2] = them[Rate2] - dt
					if them[Rate1] > 50 and not them[Unit3]:enabled() then
						them[Unit3]:set_enabled(true)
					end
				else
					them[Rate1] = 0
					them[Rate2] = nil
					them[Unit3]:set_enabled(false)
				end
			end
		end
	end)
end