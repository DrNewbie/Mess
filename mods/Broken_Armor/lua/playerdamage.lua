local ThisModPath = ModPath
local __Name = function(__id)
	return "ABC_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

--Constant
local __is_armor_broken = __Name("__is_armor_broken")
local __armor_broken_dt = __Name("__armor_broken_dt")
local __armor_broken_re = __Name("__armor_broken_re")
local ictv_armor_level = tweak_data.blackmarket.armors["level_7"].upgrade_level
local ictv_armor_var = tweak_data.upgrades.values.player.body_armor.armor[ictv_armor_level]

--Hook1
Hooks:PostHook(PlayerDamage, "_on_damage_event", __Name("_on_damage_event"), function(self)
	if self:_max_armor() > 0 and self:get_real_armor() <= 0 then --Yes, even if it is already broken, it will still reset timer.
		self[__is_armor_broken] = true		
		local my_armor_name = managers.blackmarket:equipped_armor()
		local my_armor_level = tweak_data.blackmarket.armors[my_armor_name].upgrade_level
		local my_armor_var = tweak_data.upgrades.values.player.body_armor.armor[my_armor_level]
		my_armor_var = math.max(my_armor_var, 0.1)
		if ictv_armor_var <= my_armor_var then --real?
			ictv_armor_var = my_armor_var + 1
		end		
		self[__armor_broken_dt] = ictv_armor_var * 3 - my_armor_var
	end
end)

--Hook2
local old_raw_max_armor = __Name("old_raw_max_armor")
PlayerDamage[old_raw_max_armor] = PlayerDamage[old_raw_max_armor] or PlayerDamage._raw_max_armor
function PlayerDamage:_raw_max_armor(...)
	local old_ans = self[old_raw_max_armor](self, ...)
	if self[__is_armor_broken] then
		local my_armor_name = managers.blackmarket:equipped_armor()
		local my_armor_level = tweak_data.blackmarket.armors[my_armor_name].upgrade_level
		if my_armor_level  == 1 then
			old_ans = 0 --suit, no armor
		else
			old_ans = old_ans * 0.33 --down to 33%
		end
		old_ans = math.max(old_ans, 0)
	end
	return old_ans
end

--Hook3
Hooks:PostHook(PlayerDamage, "update", __Name("update"), function(self, __unit, __t, __dt, ...)
	if self[__is_armor_broken] then
		if type(self[__armor_broken_dt]) == "number" and self[__armor_broken_dt] > 0 then
			self[__armor_broken_dt] = self[__armor_broken_dt] - __dt
			if self[__armor_broken_dt] <= 0 then
				self[__is_armor_broken] = false
				self[__armor_broken_re] = 1
			end
		end
	elseif type(self[__armor_broken_re]) == "number" and self[__armor_broken_re] > 0 and self:_max_armor() > 0 and self:get_real_armor() > 0 then
		self[__armor_broken_re] = self[__armor_broken_re] - __dt
		if self[__armor_broken_re] <= 0 then --forced armor fully recover
			self:_regenerate_armor()
			call_on_next_update(function ()
				call_on_next_update(function ()
					call_on_next_update(function ()
						self:damage_simple({
							variant = "bullet",
							damage = 0.1,
							attacker_unit = self._unit,
							pos = self._unit:position(),
							attack_dir = math.UP
						})
					end)
				end)
			end)
		end
	end
end)

--apply armor piercing
local old_damage_bullet = __Name("old_damage_bullet")
PlayerDamage[old_damage_bullet] = PlayerDamage[old_damage_bullet] or PlayerDamage.damage_bullet
function PlayerDamage:damage_bullet(__attack_data, ...)
	if self[__is_armor_broken] then
		__attack_data.armor_piercing = true
	end
	return self[old_damage_bullet](self, __attack_data, ...)
end