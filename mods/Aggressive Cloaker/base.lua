local ThisModPath = ModPath

local __Name = function(__id)
	return "GGG_"..Idstring(tostring(__id).."::"..ThisModPath):key()
end

if not _G[__Name(0)] and SpoocLogicAttack then
	_G[__Name(0)] = true
	SpoocLogicAttack[__Name(0)] = SpoocLogicAttack[__Name(0)] or SpoocLogicAttack._upd_spooc_attack
	function SpoocLogicAttack._upd_spooc_attack(data, my_data, ...)
		if data.unit and data.unit:inventory() and data.unit:inventory()[__Name("super aggressive")] then
			local focus_enemy = data.attention_obj
			if focus_enemy.nav_tracker and focus_enemy.is_person and focus_enemy.criminal_record and not focus_enemy.criminal_record.status and not my_data.spooc_attack and not focus_enemy.unit:movement():zipline_unit() and focus_enemy.unit:movement():is_SPOOC_attack_allowed() then
				if focus_enemy.verified then
					if my_data.attention_unit ~= focus_enemy.u_key then
						CopLogicBase._set_attention(data, focus_enemy)
						my_data.attention_unit = focus_enemy.u_key
					end
					local action = SpoocLogicAttack._chk_request_action_spooc_attack(data, my_data)
					if action then
						my_data.spooc_attack = {
							start_t = data.t,
							target_u_data = focus_enemy,
							action = action
						}
						return true
					end
				end
				if ActionSpooc.chk_can_start_flying_strike(data.unit, focus_enemy.unit) then
					if my_data.attention_unit ~= focus_enemy.u_key then
						CopLogicBase._set_attention(data, focus_enemy)
						my_data.attention_unit = focus_enemy.u_key
					end
					local action = SpoocLogicAttack._chk_request_action_spooc_attack(data, my_data, true)
					if action then
						my_data.spooc_attack = {
							start_t = data.t,
							target_u_data = focus_enemy,
							action = action
						}
						return true
					end
				end
			end
		end
		return SpoocLogicAttack[__Name(0)](data, my_data, ...)
	end
end

if not _G[__Name(1)] and CopInventory then
	_G[__Name(1)] = true
	Hooks:PostHook(CopInventory, "init", __Name(1), function(self, ...)
		if self._unit and alive(self._unit) and math.random() >= 0.67 then
			if self._unit:base()._tweak_table == "spooc" and type(self._unit.effect_spawner) == "function" and self._unit:effect_spawner(Idstring("burning_flames_001")) then
				call_on_next_update(function()
					pcall(function()
						self[__Name("super aggressive")] = true
						self._unit:effect_spawner(Idstring("burning_flames_001")):set_enabled(true)
						self._unit:effect_spawner(Idstring("burning_flames_001")):activate(true)
						self._unit:effect_spawner(Idstring("burning_flames_002")):set_enabled(true)
						self._unit:effect_spawner(Idstring("burning_flames_002")):activate(true)
						self._unit:effect_spawner(Idstring("burning_flames_003")):set_enabled(true)
						self._unit:effect_spawner(Idstring("burning_flames_003")):activate(true)
						self._unit:effect_spawner(Idstring("burning_flames_004")):set_enabled(true)
						self._unit:effect_spawner(Idstring("burning_flames_004")):activate(true)
						self._unit:effect_spawner(Idstring("burning_flames_005")):set_enabled(true)
						self._unit:effect_spawner(Idstring("burning_flames_005")):activate(true)
					end)
				end)
			end
		end
		return true
	end)
end


--[[
	pcall(function()
		self._unit:effect_spawner(Idstring("burning_flames_001")):set_enabled(false)
		self._unit:effect_spawner(Idstring("burning_flames_001")):kill_effect(false)
	end)
]]