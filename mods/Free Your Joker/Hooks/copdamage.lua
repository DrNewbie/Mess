function CopDamage:asked_to_huge()
	local tcop = nil
	local allow_cops = {}
	for _, data in pairs(managers.enemy:all_enemies()) do
		if not data.is_converted and self._unit ~= data.unit then
			table.insert(allow_cops, data.unit)
		end
	end
	tcop = table.random(allow_cops)
	if tcop then
		local dis = mvector3.distance(self._unit:position(), tcop:position())
	
		local followup_objective = {
			type = "act",
			scan = true,
			action = {
				type = "act", body_part = 1, variant = "crouch", 
				blocks = {walk = -1, aim = -1}
			}
		}
		local objective = {
			type = "e_so_container_kick",
			follow_unit = self._unit,
			called = true,
			destroy_clbk_key = false,
			nav_seg = self._unit:movement():nav_tracker():nav_segment(),
			pos = tcop:position(),
			scan = true,
			action = {
				type = "act", variant = "e_so_container_kick", body_part = 1,
					blocks = {walk = -1, aim = -1},
					align_sync = true
			},
			action_duration = 3 + (dis/500),
			followup_objective = followup_objective,
			complete_clbk = callback(self, self, "HugeItNow", {}),
			fail_clbk = callback(self, self, "HugeItNow", {})
		}
		self:set_invulnerable(true)
		self._unit:brain():set_objective(objective)
		
		if self._unit:contour() then
			self._unit:contour():add("deployable_active")
			self._unit:contour():flash("deployable_active", 0.2)
		end
	end
end

function CopDamage:HugeItNow()	
	local pos = self._unit:movement():m_head_pos()	
	local normal = math.UP
	local slot_mask = managers.slot:get_mask("explosion_targets")
	local range = 2000
	local damage = (self._HEALTH_INIT or 1) * 2.5
	local ply_damage = 0.1
	local curve_pow = 6
	
	local damage_params = {
		no_raycast_check_characters = false,
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = curve_pow,
		damage = damage,
		player_damage = ply_damage,
		ignore_unit = self._unit
	}
	
	local effect_params = {
		sound_event = "grenade_explode",
		effect = "effects/payday2/particles/explosions/grenade_explosion",
		camera_shake_max_mul = 4,
		sound_muffle_effect = true,
		feedback_range = range * 2
	}
	
	managers.explosion:give_local_player_dmg(pos, range, ply_damage)
	managers.explosion:play_sound_and_effects(pos, normal, range, effect_params)
	managers.explosion:detect_and_give_dmg(damage_params)
	managers.network:session():send_to_peers_synched("sync_explosion_to_client", self._unit, pos, normal, ply_damage, range, curve_pow)
		
	self:set_invulnerable(false)
	self:damage_mission({
		damage = 100000,
		forced = true
	})
end