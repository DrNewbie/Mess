Hooks:PreHook(GageAssignmentInteractionExt, "interact", "F_"..Idstring("PreHook:GageAssignmentInteractionExt:interact:Gage Powerup Packages"):key(), function(self, player)
	if self._tweak_data and self.tweak_data == "gage_assignment" and player and self._unit and alive(player) and alive(self._unit) and player:character_damage() and player == managers.player:player_unit() and not self._unit:base()._picked_up then
		self._unit:base()._picked_up_from_me = player
	end
end)

Hooks:PostHook(GageAssignmentInteractionExt, "interact", "F_"..Idstring("PostHook:GageAssignmentInteractionExt:interact:Gage Powerup Packages"):key(), function(self, player)
	if self._tweak_data and self.tweak_data == "gage_assignment" and player and self._unit and self._unit:base()._picked_up and self._unit:base()._picked_up_from_me and alive(player) and alive(self._unit) and alive(self._unit:base()._picked_up_from_me) and self._unit:base()._picked_up_from_me == player and player == managers.player:player_unit() then
		local _type = tostring(self._unit:base()._assignment)
		local _buffs = {
			["green_mantis"] = function (ply) --10s bullet storm + ammo bag replenish 
				managers.player:add_to_temporary_property("bullet_storm", 10, 1)
				local inventory = ply:inventory()
				if inventory then
					for _, weapon in pairs(inventory:available_selections()) do
						weapon.unit:base():add_ammo_from_bag(100)
					end
				end
				HudChallengeNotification.queue(
					"[ Powerup ]",
					"Green Mantis: Bulletstorm for 10 seconds. FULL Ammo.",
					"equipment_gasoline"
				)
			end,
			["yellow_bull"] = function (ply) --first aid kit regenerate
				ply:character_damage():band_aid_health()
				HudChallengeNotification.queue(
					"[ Powerup ]",
					"Yellow Bull: Full HP.",
					"equipment_gasoline"
				)
			end,
			["red_spider"] = function (ply) --medic bag regenerate
				ply:character_damage():recover_health()
				HudChallengeNotification.queue(
					"[ Powerup ]",
					"Red Spider: Full HP and resets your down counter.",
					"equipment_gasoline"
				)
			end
			,
			["blue_eagle"] = function (ply) --10s no dmg
				ply:character_damage()._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + 10, true)
				ply:character_damage()._last_received_dmg = math.huge
				HudChallengeNotification.queue(
					"[ Powerup ]",
					"Blue Eagle: God Mode for 10 seconds.",
					"equipment_gasoline"
				)
			end,
			["purple_snake"] = function (ply) --LOUD ONLY, 10s burn all enemies
				if not managers.groupai:state():whisper_mode() then
					managers.player:ask_loop_fire_to_all(10)
					HudChallengeNotification.queue(
						"[ Powerup ]",
						"Purple Snake: Burn All enemies for 10 seconds.",
						"equipment_gasoline"
					)
				end
			end
		}
		if type(_buffs[_type]) == "function" then
			_buffs[_type](player)
		end
	end
end)