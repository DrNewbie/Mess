local ThisModPath = ModPath
local ThisBuffer
if blt.xaudio then
	blt.xaudio.setup()
	ThisBuffer = XAudio.Buffer:new(ThisModPath .. "/assets/ogg_197155c7de1ca8e0.ogg")
end
local mod_ids = Idstring(ThisModPath):key()
local __using_dt = "F_"..Idstring("__using_dt:"..mod_ids):key()
local __using_ft = "F_"..Idstring("__using_ft:"..mod_ids):key()
local __eating_ogg = "F_"..Idstring("__eating_ogg:"..mod_ids):key()
local __eating_unit = "F_"..Idstring("__eating_unit:"..mod_ids):key()

function PlayerManager:__is_look_at_bags_yes(__unit)
	if not Utils or not Utils:IsInHeist() then
		return false
	end
	__unit = __unit or self:local_player()
	if not __unit or not alive(__unit) or not self:local_player() or not alive(self:local_player()) or __unit ~= self:local_player() then
		return false
	end
	local camera = self:local_player():movement()._current_state._ext_camera
	local mvec_to = Vector3()
	local from_pos = camera:position()
	mvector3.set(mvec_to, camera:forward())
	mvector3.multiply(mvec_to, 200)
	mvector3.add(mvec_to, from_pos)
	local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", World:make_slot_mask(14))
	if col_ray and col_ray.unit then
		local __unit = col_ray.unit
		if __unit and type(__unit) == "userdata" and alive(__unit) then
			if __unit:interaction() and __unit:interaction():can_select(self:local_player()) and __unit.carry_data and __unit:carry_data() and __unit:carry_data():carry_id() and __unit:carry_data():carry_id() == "person" then
				self[__eating_unit] = __unit
				return true
			end
		end
	end	
	return false
end

function PlayerManager:__stop_eat_body_bag_ogg()
	if ThisBuffer then
		if self[__eating_ogg] then
			self[__eating_ogg]:close(true)
			self[__eating_ogg] = nil
		end
	end
	return
end

function PlayerManager:__play_eat_body_bag_ogg()
	if ThisBuffer then
		self:__stop_eat_body_bag_ogg()
		self[__eating_ogg] = XAudio.Source:new(ThisBuffer)
	end
	return
end

function PlayerManager:__use_eat_body_bag_system()
	if self:__is_look_at_bags_yes() then
		self[__using_ft] = 15.90
		self[__using_dt] = self[__using_ft]
		self:__play_eat_body_bag_ogg()
	end
	return
end