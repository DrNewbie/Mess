local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "H_"..Idstring("Hook1::"..ThisModIds):key()
local Hook2 = "H_"..Idstring("Hook2::"..ThisModIds):key()
local Hook3 = "H_"..Idstring("Hook3::"..ThisModIds):key()
local Hook4 = "H_"..Idstring("Hook4::"..ThisModIds):key()
local Bool1 = "B_"..Idstring("Bool1::"..ThisModIds):key()
local Unit1 = "U_"..Idstring("Unit1::"..ThisModIds):key()
local Unit2 = "U_"..Idstring("Unit2::"..ThisModIds):key()
local Unit3 = "U_"..Idstring("Unit3::"..ThisModIds):key()
local Rate1 = "R_"..Idstring("Rate1::"..ThisModIds):key()
local Rate2 = "R_"..Idstring("Rate2::"..ThisModIds):key()

if NewRaycastWeaponBase then
	Hooks:PostHook(NewRaycastWeaponBase, "setup", Hook1, function(self)
		if not self[Bool1] then
			self[Bool1] = true
			local __part = self._parts[table.random_key(self._parts)]
			if __part and __part.unit and alive(__part.unit) and __part.unit.orientation_object and __part.unit:orientation_object() then
				self[Unit2] = __part.unit
				self[Unit3] = nil
			end
			self[Rate1] = 0
			self[Rate2] = 0
		end
	end)
	Hooks:PostHook(NewRaycastWeaponBase, "fire", Hook2, function(self)
		if self[Bool1] and self[Unit2] and self._shooting then
			if self[Unit3] and self[Rate1] == -1 then
				self:dryfire()
			else
				self[Rate1] = self[Rate1] or 0
				self[Rate1] = self[Rate1] + math.random()*3
				self[Rate2] = 5
			end
		end
	end)
end

if PlayerStandard then
	Hooks:PostHook(PlayerStandard, "_update_check_actions", Hook3, function(self, t, dt)
		if self._ext_inventory and self._ext_inventory:equipped_unit() then
			local them = self._ext_inventory:equipped_unit():base()
			if them and them[Unit2] and type(them[Rate2]) == "number" and type(them[Rate1]) == "number" then
				if them[Rate2] > 0 then
					them[Rate2] = them[Rate2] - dt
					if them[Unit3] and them[Rate1] == -1 then
						them._next_fire_allowed = them._unit:timer():time() + 1 + dt
					end
					if them[Rate1] > 50 and not them[Unit3] then						
						them[Unit3] = World:effect_manager():spawn({
							effect = Idstring("effects/payday2/particles/weapons/rpg_smoke_trail"),
							parent = them[Unit2]:orientation_object()
						})
					end
					if them[Unit3] and them[Rate1] > 150 then
						them[Rate1] = -1
						them[Rate2] = 15
						local shoot_pos = them[Unit2]:position()
						local range = ConcussionGrenade._PLAYER_FLASH_RANGE * 2
						local user_unit = managers.player:local_player()
						local sound_eff_mul = 2
						managers.explosion:play_sound_and_effects(shoot_pos, math.UP, range, {
							camera_shake_max_mul = 4,
							effect = "effects/particles/explosions/explosion_flash_grenade",
							sound_event = "concussion_explosion",
							feedback_range = range
						})
						local detonate_pos = shoot_pos + math.UP * 100
						local affected, line_of_sight, travel_dis, linear_dis = QuickFlashGrenade._chk_dazzle_local_player(user_unit:base(), detonate_pos, range)
						managers.environment_controller:set_concussion_grenade(detonate_pos, line_of_sight, travel_dis, linear_dis, tweak_data.character.concussion_multiplier)
						managers.player:player_unit():character_damage():on_concussion(sound_eff_mul)
						World:effect_manager():spawn({
							effect = Idstring("effects/particles/explosions/explosion_grenade"),
							position = shoot_pos,
							normal = them[Unit2]:rotation():y()
						})
						local sound_source = SoundDevice:create_source("TripMineBase")
						sound_source:set_position(shoot_pos)
						sound_source:post_event("trip_mine_explode")
						managers.enemy:add_delayed_clbk("TrMiexpl", callback(TripMineBase, TripMineBase, "_dispose_of_sound", {
							sound_source = sound_source
						}), TimerManager:game():time() + 4)
						them:set_ammo_remaining_in_clip(0)
						them:set_ammo_total(0)
						local w_index = managers.player:equipped_weapon_index()
						managers.hud:set_ammo_amount(w_index, them:ammo_info())
						local damage_ext = user_unit:character_damage()
						if damage_ext then
							damage_ext:_calc_health_damage({damage = 6, variant = "melee"})
						end
					end
				else
					them[Rate1] = 0
					them[Rate2] = nil
					World:effect_manager():fade_kill(them[Unit3])
					World:effect_manager():kill(them[Unit3])
					them[Unit3] = nil
				end
			end
		end
	end)
end