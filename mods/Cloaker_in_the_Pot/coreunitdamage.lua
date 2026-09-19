local ThisModPath = tostring(ModPath)
local __NameIds = function(__data)
	return "CiP_"..Idstring(ThisModPath..string.format("%q", __data)):key()
end

core:import("CoreSequenceManager")

if (Network and Network:is_server()) or (Global.game_settings and Global.game_settings.single_player) then
	--Yes
else
	--Not Host
	return
end

CoreUnitDamage = CoreUnitDamage or class()
CoreUnitDamage.ALL_TRIGGERS = "*"
UnitDamage = UnitDamage or class(CoreUnitDamage)
local ids_damage = Idstring("damage")

local __rate = 0.8

local is_breakable = __NameIds("is_breakable")
local bullet_hp = __NameIds("bullet_hp")
local melee_hp = __NameIds("melee_hp")
local explosion_hp = __NameIds("explosion_hp")

Hooks:PostHook(CoreBodyDamage, "init", __NameIds("CoreBodyDamage:init"), function(self, ...)
	if __rate >= math.random() and 
		type(self._endurance) == "table" and 
		type(self._endurance.bullet) == "table" and 
		type(self._endurance.bullet._unit_element) == "table" and 
		type(self._endurance.bullet._unit_element.has_sequence) == "function" then
		local __ele = self._endurance.bullet._unit_element
		if __ele:has_sequence("int_seq_bullet_hit") then
			self[is_breakable] = true
		elseif __ele:has_sequence("int_seq_explosion") then
			self[is_breakable] = true
		end
		if self[is_breakable] then
			self[bullet_hp] = self._endurance.bullet._parameters.bullet
			self[melee_hp] = self._endurance.bullet._parameters.melee
			self[explosion_hp] = self._endurance.bullet._parameters.explosion
			local base_me = self._unit_extension
			local body_me = self
			if type(base_me) == "table" and 
				type(base_me.add_damage) == "function" then	
				local old_add_damage = base_me.add_damage
				base_me.add_damage = function(them, endurance_type, ...)
					local damage_hp = __NameIds(""..tostring(endurance_type).."_hp")
					if type(body_me[damage_hp]) == "number" then
						body_me[damage_hp] = body_me[damage_hp] - 1
						if body_me[damage_hp] <= 0 then
							DelayedCalls:Add(__NameIds(tostring(base_me)), 0.015, function()
								local unit_name = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
								local unit_done = safe_spawn_unit(unit_name, base_me._unit:position(), Rotation())
								if unit_done then
									local team_id = tweak_data.levels:get_default_team_ID(unit_done:base():char_tweak().access == "gangster" and "gangster" or "combatant")
									unit_done:movement():set_team(managers.groupai:state():team_data( team_id ))
									managers.groupai:state():assign_enemy_to_group_ai(unit_done, team_id)
								end
							end)
						end
					end
					return old_add_damage(them, endurance_type, ...)
				end
			end
		end
	end
end)