local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Main1 = "F_"..Idstring("Main1::"..ThisModIds):key()

Concussion9BangGrenade = Concussion9BangGrenade or class(ConcussionGrenade)
Concussion9BangGrenade._PLAYER_FLASH_RANGE = 500

function Concussion9BangGrenade:_detonate(...)
	self.__is_detonate = true
	self.__detonate_pos = self._unit:position()
	self.__detonate_times = 9
	self.__detonate_dt = 0.75
end

Hooks:PostHook(Concussion9BangGrenade, "update", Main1, function(self, __unit, __t, __dt)
	if self._unit and alive(self._unit) and self.__is_detonate then
		if type(self.__detonate_times) == "number" and self.__detonate_times > 0 then
			if type(self.__detonate_dt) == "number" then
				self.__detonate_dt = self.__detonate_dt - __dt
				if self.__detonate_dt <= 0 then
					self.__detonate_dt = 0.75
					self.__detonate_times = self.__detonate_times - 1
					local pos = self.__detonate_pos
					local normal = math.UP
					local range = self._range
					local slot_mask = managers.slot:get_mask("explosion_targets")
					managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)
					local hit_units, splinters = managers.explosion:detect_and_stun({
						player_damage = 0,
						hit_pos = pos,
						range = range,
						collision_slotmask = slot_mask,
						curve_pow = self._curve_pow,
						damage = self._damage,
						ignore_unit = self._unit,
						alert_radius = self._alert_radius,
						user = self:thrower_unit() or self._unit,
						owner = self._unit,
						verify_callback = callback(self, self, "_can_stun_unit")
					})
					managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
					self:_flash_player()
				end
			end
		else
			self.__is_detonate = nil
			self.__detonate_times = nil
			self.__detonate_dt = nil
			self.__detonate_pos = nil
			self._unit:set_slot(0)
		end
	end
end)

if Network and Network:is_client() then
	tweak_data.blackmarket.projectiles.concussion.name_id = "bm_concussion_9_bang_not_working"
end