local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook1 = "F_"..Idstring("Hook1::"..ThisModIds):key()
local Bool1 = "F_"..Idstring("Bool1::"..ThisModIds):key()
local __Dt1 = "F_"..Idstring("__Dt1::"..ThisModIds):key()

function PlayerStandard:Ask_Bot_Use_Min_Equipment()
	if not managers.groupai:state():whisper_mode() then
		self[Bool1] = true
	end
end

local function __is_aiming_at_team_bot(__camera)
	if not __camera then
		return nil
	end
	local __from = __camera:position()
	local __to = __from + __camera:forward() * 1000
	local __ray = World:raycast("ray", __from, __to, "slot_mask", managers.slot:get_mask("criminals"))
	if type(__ray) == "table" and __ray.hit_position and __ray.unit then
		return __ray.unit
	end
	return nil
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", Hook1, function(self, __t, __dt)
	if self[__Dt1] then
		self[__Dt1] = self[__Dt1] - __dt
		if self[__Dt1] < 0 then
			self[__Dt1] = nil
		end
	end
	if self[Bool1] and not self[__Dt1] and type(BotWeapons) == "table" and type(BotWeapons._loadouts) == "table" then
		self[Bool1] = false	
		if not self._intimidate_t or tweak_data.player.movement_state.interaction_delay < __t - self._intimidate_t then
			local prime_target = __is_aiming_at_team_bot(self._ext_camera)
			if type(prime_target) ~= "userdata" or type(prime_target.inventory) ~= "function" or not prime_target:inventory() or type(prime_target:inventory().min_equipment_amount) ~= "function" then
			
			else
				if not prime_target:inventory().__bot_min_equipment_init then
					prime_target:inventory().__bot_min_equipment_init = true
					local char_name = managers.criminals:character_name_by_unit(prime_target)
					if type(char_name) == "string" then
						local __char_loadout = BotWeapons._loadouts[char_name]
						if type(__char_loadout.deployable) == "string" then
							prime_target:inventory():set_min_equipment(__char_loadout.deployable)
						end
					end
				end
				local min_equipment_amount = prime_target:inventory():min_equipment_amount()
				if type(min_equipment_amount) == "number" and min_equipment_amount > 0 then
					local min_equipment = prime_target:inventory():min_equipment() or nil
					if min_equipment then
						local unit_min, pos, rot
						pos = prime_target:position()
						rot = prime_target:rotation()				
						if min_equipment == "ammo_bag" then
							unit_min = AmmoBagBase.spawn(pos, rot, 0, 0, 0)
						elseif min_equipment == "doctor_bag" then
							unit_min = DoctorBagBase.spawn(pos, rot, 0, 0)
						end
						if unit_min and alive(unit_min) then
							self[__Dt1] = 1
							prime_target:inventory():reduce_min_equipment_amount(true)
							unit_min:base():set_min(true)
							self:say_line("g18", skip_alert)
							if prime_target:inventory():min_equipment_amount() <= 0 then
								local visual_object = tweak_data.equipments[min_equipment] and tweak_data.equipments[min_equipment].visual_object
								local mesh_obj = prime_target:get_object(Idstring(visual_object))
								if mesh_obj then
									mesh_obj:set_visibility(false)
								end
							end
						end
					end
				end
			end
		end
	end
end)
