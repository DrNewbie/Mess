local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local hook1 = "F"..Idstring("hook1::"..mod_ids):key()
local bool1 = "F"..Idstring("bool1::"..mod_ids):key()

Hooks:PostHook(CopDamage, "_on_damage_received", hook1, function(self, attack_data)
	if math.random() <= 0.15 and type(attack_data) == "table" and not attack_data[bool1] and attack_data.weapon_unit and attack_data.weapon_unit:base() and attack_data.weapon_unit:base()._blueprint and table.contains(attack_data.weapon_unit:base()._blueprint, "wpn_fps_upg_charm_cloaker") and attack_data.attacker_unit == managers.player:player_unit() then
		local player_unit = managers.player:player_unit()
		player_unit:sound():play("cloaker_detect_mono", nil, nil)
		self:stun_hit({
			["variant"] = "stun",
			["damage"] = 0,
			["attacker_unit"] = player_unit,
			["weapon_unit"] = attack_data.weapon_unit,
			["col_ray"] = attack_data.col_ray or {position = self._unit:position(), ray = math.UP},
			[bool1] = true			
		})
	end
end)